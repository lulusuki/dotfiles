{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.flake-file.flakeModules.default
    inputs.home-manager.flakeModules.home-manager
    (lib.mkAliasOptionModule [ "inputs" ] [ "flake-file" "inputs" ])
  ];

  # Temp
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  inputs.home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  # End Temp

  disabledModules = [ (inputs.flake-file + "/modules/flake-parts.nix") ];

  perSystem =
    { pkgs, ... }:
    {
      apps =
        config.flake-file.apps
         |> lib.mapAttrs (
          _: f:
          let
            pkg = f pkgs;
          in
          {
            type = "app";
            program = lib.getExe pkg;
          }
        );

      checks.check-flake-file = config.flake-file.check-flake-file pkgs;
    };

  flake-file = {
    inputs.flake-file.url = "github:denful/flake-file";

    description = "Lulu's nix configuration";
    
    outputs = /* nix */ ''
      inputs:
      let
        evaluation = inputs.flake-parts.lib.evalFlakeModule { inherit inputs; } {
          # Import all *.nix files in the ./modules directory
          # Except ones that start with '_'
          imports =
            with inputs.nixpkgs.lib;
            ./modules
            |> fileset.fileFilter (file: file.hasExt "nix" && !hasPrefix "_" file.name)
            |> fileset.toList;

          _module.args.rootPath = ./.;
        };
      in
      { inherit evaluation; } // evaluation.config.processedFlake
    '';

    do-not-edit = ''
      # ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░░▒▓███████▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░
      # ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░
      # ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░
      # ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░░▒▓█▓▒░
      # ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░
      # ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░
      # ░▒▓████████▓▒░▒▓██████▓▒░░▒▓████████▓▒░▒▓██████▓▒░░▒▓███████▓▒░ ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░
      #
      # This file is generated with flake-file. Any edits will be overwritten.
    '';
  };
}

