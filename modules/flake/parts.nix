{ inputs, lib, ... }:
{
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";

  imports = [
    (lib.mkAliasOptionModule [ "nm" ] [ "flake" "nixosModules" ])
    (lib.mkAliasOptionModule [ "hm" ] [ "flake" "homeModules" ])
  ];

  systems = [ "x86_64-linux" ];

  perSystem =
    { system, ... }:
    let
      config.allowUnfree = true;
      pkgs = import inputs.nixpkgs { inherit system config; };
    in
    {
      # initialize the pkgs for perSystem to be the patched nixpkgs
      _module.args = { inherit pkgs; };

      _file = ./parts.nix;
    };

  _file = ./parts.nix;
}
