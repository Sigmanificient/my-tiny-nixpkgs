#!/usr/bin/env bash
set -euo pipefail

MAINTAINER=$(cat whoami)
MY_PACKAGES=$(nix eval --impure --json --expr "
  (import ./list-my-packages.nix) {
    pkgs = (import ${MY_TINY_NIXPKGS_SOURCE} {});
    maintainer = \"${MAINTAINER}\";
  }
" | jq -c '.[]')

rm -rf pkgs flatten
mkdir -p pkgs flatten

echo "$MY_PACKAGES" | while read -r pkg; do
  name=$(echo "$pkg" | jq -r '.name')
  position=$(echo "$pkg" | jq -r '.position')

  echo "=> $name"

  file_path=${position%%:*}
  dir_path=$(dirname "$file_path")

  rel_path=${dir_path#${MY_TINY_NIXPKGS_SOURCE}/}
  dest_dir="./$rel_path"

  mkdir -p "$dest_dir"

  cp -a "$dir_path/." "$dest_dir/"
  chmod -R u+rw "$dest_dir"

  ln -s "../$dest_dir" "flatten/$name"
done

echo "Done!"
