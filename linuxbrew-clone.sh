#!/usr/bin/env bash

# Copyright (c) YugaByte, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
# in compliance with the License.  You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License
# is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied.  See the License for the specific language governing permissions and limitations
# under the License.
#

# This script creates a new Linuxbrew directory by cloning the upstream GitHub repository. The
# directory path is chosen to be of a fixed length, and a more human-readable symlink is created
# to point to the resulting directory.

set -euo pipefail

. "${0%/*}/linuxbrew-common.sh"

brew_path_prefix=$(get_brew_path_prefix)
git clone https://github.com/Homebrew/brew "$brew_path_prefix"
brew_home=$(get_fixed_length_path "$brew_path_prefix")
mv "$brew_path_prefix" "$brew_home"

echo "$brew_home" >latest_brew_clone_dir.txt
