#!/usr/bin/env bash

set -euo pipefail

. "${BASH_SOURCE%/*}/linuxbrew-common.sh"

this_repo_top_dir=$( cd "$( dirname "$0" )" && git rev-parse --show-toplevel )
if [[ ! -d $this_repo_top_dir ]]; then
  fatal "Failed to determine the top directory of the Git repository containing this script"
fi

export USER=$( whoami )
repo_dir=$PWD
timestamp=$( date +%Y-%m-%dT%H_%M_%S )
num_commits=$( git rev-list --count HEAD )
num_commits=$( printf "%06d" $num_commits )
set_brew_timestamp
tag=$YB_BREW_TIMESTAMP
linuxbrew_dir=/opt/yb-build/linuxbrew
mkdir -p "$linuxbrew_dir"
cd "$linuxbrew_dir"
#"$repo_dir/linuxbrew-clone-and-build-all.sh"

create_release_cmd=( hub release create "$tag" -m "Release $tag" )
for f in "$YB_BREW_DIR_PREFIX-$YB_BREW_TIMESTAMP-*"; do
  if [[ -f $f ]]; then
    create_release_cmd+=( -a "$f" )
  fi
done
cd "$this_repo_top_dir"
set -x
git tag "$tag"
"${create_release_cmd[@]}"
