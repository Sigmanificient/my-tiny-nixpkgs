let
  nixpkgs = builtins.getEnv "MY_TINY_NIXPKGS_SOURCE";

  pkgs = import nixpkgs { };
in
import ./packages.nix { inherit pkgs; }
