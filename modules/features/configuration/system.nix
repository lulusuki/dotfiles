{ inputs, ... }:
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-core.url = "github:manic-systems/nixos-core/refs/tags/v1.0.1";
  };

  nm.default =
    {
      lib,
      constants,
      ...
    }:
    {
      imports = [ inputs.nixos-core.nixosModules.default ];

      nix.settings = {
        use-xdg-base-directories = true;
        warn-dirty = false;
        auto-optimise-store = true;
        allow-imports-from-derivation = false;
        experimental-features = [
          "pipe-operators"
          "nix-command"
          "flakes"
        ];

        trusted-users = [
          "root"
          "@wheel"
        ];

        substituters = [
          "https://hyprland.cachix.org"
        ];

        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];

        extra-substituters = [
          "https://yazi.cachix.org"
        ];

        extra-trusted-public-keys = [
          "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
        ];

      };

      services.speechd.enable = lib.mkForce false; # Disable tts

      nixpkgs.config = {
        allowUnfree = true;
      };

      system.stateVersion = constants.stateVersion;
    };
}
