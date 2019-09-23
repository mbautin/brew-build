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
tar cvzf "$top_dir_name.tar.gz" "$linuxbrew_dir"
create_release_cmd=( hub release create "$tag" -m "Release $tag" )
for f in *.tar.gz; do
  create_release_cmd+=( -a "$PWD/$top_dir_name.tar.gz" )
done
"${create_release_cmd[@]}"
cd "$linuxbrew_dir"
"$repo_dir/linuxbrew-clone-and-build-all.sh"
cd "$repo_dir"
