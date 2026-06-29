{ inputs, ... }:
{

  inputs.yazi.url = "github:sxyazi/yazi";

  hm.default =
    {
      pkgs,
      lib,
      ...
    }:
    let
      audio-preview = pkgs.yaziPlugins.mkYaziPlugin {
        pname = "audio-preview";
        version = "0.67";

        src = lib.cleanSourceWith {
          src = pkgs.fetchFromGitHub {
            owner = "lulusuki";
            repo = "audio-preview.yazi";
            rev = "7337a5e4a779de83d16bf4d44a7686f955368ca2";
            hash = "sha256-1vWcULsE2vQo5mV9ciCWXnOJQsgIxEgWUGLlNMX/UxA=";
          };
        };
      };
    in
    {
      home.packages = with pkgs; [
        zoxide
        sox
      ];

      programs.yazi = {
        enable = true;

        package = inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
          _7zz = pkgs._7zz-rar;
          zoxide = pkgs.zoxide;
        };

        settings = builtins.fromTOML (builtins.readFile ./settings.toml);

        initLua = ./init.lua;

        plugins = {
          audio-preview = audio-preview;
        };
      };

      xdg.configFile."yazi/flavors" = {
        source = ./flavors;
        recursive = true;
      };
    };
}
