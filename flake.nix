{
  description = "Reproducible (continuation) of Brotli decoder releases for Java (seems discontinued upstream)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        {
          system,
          pkgs,
          self',
          ...
        }:

        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              (final: _prev: {
                jdk = final.jdk21;
                jdk_headless = final.jdk21_headless;
              })
            ];
          };

          treefmt = {
            programs.nixfmt.enable = true;
          };

          packages = {
            default = pkgs.callPackage ./package.nix { };
            brotli-dec = self'.packages.default;
          };

          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.curl
              pkgs.jdk
              pkgs.jq
              pkgs.maven
              (pkgs.writeShellScriptBin "tag-release" ''
                version="$(nix eval --raw ".#default.version")"
                git tag -m "Release $version" "v$version" "$@"
              '')
            ];
          };
        };
    };
}
