#!/usr/bin/env bash

set -euxo pipefail
export USER=$( whoami )
repo_dir=$PWD
timestamp=$( date +%Y-%m-%dT%H_%M_%S )
num_commits=$( git rev-list --count HEAD )
num_commits=$( printf "%06d" $num_commits )
tag=v${timestamp}__${num_commits}__$( git rev-parse HEAD )
top_dir_name=yb-linuxbrew-$tag
linuxbrew_dir=/opt/yugabyte-build/linuxbrew-versions/$top_dir_name
mkdir -p "$linuxbrew_dir"
touch "$linuxbrew_dir"/foo
touch "$linuxbrew_dir"/far
archives_dir=/opt/yugabyte-build/linuxbrew-archives
mkdir -p "$archives_dir"
archive_name="$top_dir_name.tar.gz"
archive_path="$archives_dir/$archive_name"
cd "$archives_dir"
tar cvzf "$archive_path" "$linuxbrew_dir"
create_release_cmd=( hub release create "$tag" -m "Release $tag" )
for f in *.tar.gz; do
  create_release_cmd+=( -a "$archive_path" )
done
"${create_release_cmd[@]}"
cd "$linuxbrew_dir"
"$repo_dir/linuxbrew-clone-and-build-all.sh"
cd "$repo_dir"
