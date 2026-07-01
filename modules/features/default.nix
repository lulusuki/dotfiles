{ inputs, ... }:
{
  inputs.zen-browser = {
    url = "github:youwen5/zen-browser-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  nm.default = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      mpv
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      (vivaldi.override {
        proprietaryCodecs = true;
        enableWidevine = false;
      })
      vivaldi-ffmpeg-codecs
    ];
  };

  hm.default = { pkgs, ... }: {

  };
}
