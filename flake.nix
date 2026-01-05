{
  description = "my tiny nixpkgs";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      applySystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      eachSystem =
        f:
        applySystems (
          system:
          f {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          }
        );
    in
    {
      formatter = eachSystem ({ pkgs, ... }: pkgs.nixfmt-tree);

      devShells = eachSystem (
        {
          pkgs,
          ...
        }:
        {
          default = pkgs.mkShell {
            env.MY_TINY_NIXPKGS_SOURCE = nixpkgs.outPath;

            packages = [
              pkgs.jq
            ];
          };
        }
      );
    };
}
