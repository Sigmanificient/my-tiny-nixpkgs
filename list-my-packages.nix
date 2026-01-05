/**
  Example usage:

  nix eval --impure  --json --expr '
    (import ./list-my-packages.nix) {
     pkgs = import <nixpkgs> {};
     maintainer = "sigmanificient";
    }'

  *
*/
{ pkgs, maintainer }:

let
  # Borrowed from maintainers/scripts/check-hydra-by-maintainer.nix
  inherit (pkgs) lib;

  maintainer_ = pkgs.lib.maintainers.${maintainer};
  packagesWith =
    cond: return: prefix: set:
    (lib.flatten (
      lib.mapAttrsToList (
        name: pkg:
        let
          result = builtins.tryEval (
            if lib.isDerivation pkg && cond name pkg then
              # Skip packages whose closure fails on evaluation.
              # This happens for pkgs like `python27Packages.djangoql`
              # that have disabled Python pkgs as dependencies.
              builtins.seq pkg.outPath [ (return pkg "${prefix}${name}") ]
            else if
              pkg.recurseForDerivations or false || pkg.recurseForRelease or false
            # then packagesWith cond return pkg
            then
              packagesWith cond return "${name}." pkg
            else
              [ ]
          );
        in
        if result.success then result.value else [ ]
      ) set
    ));

  packages =
    builtins.trace "evaluating list of packages for maintainer: ${maintainer}" packagesWith
      (
        name: pkg:
        (
          if builtins.hasAttr "meta" pkg && builtins.hasAttr "maintainers" pkg.meta then
            (
              if builtins.isList pkg.meta.maintainers then
                builtins.elem maintainer_ pkg.meta.maintainers
              else
                maintainer_ == pkg.meta.maintainers
            )
          else
            false
        )
      )
      (pkg: name: {
        inherit name;
        inherit (pkg.meta) position;
      })
      ""
      pkgs;

in
packages
