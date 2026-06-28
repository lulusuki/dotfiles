{
  hm.lulu = { config, pkgs, ... }: {
    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
        extraConfig.XDG_PROJECTS_DIR = "${config.home.homeDirectory}/Projects";
        extraConfig.XDG_CAPTURES_DIR = "${config.home.homeDirectory}/Videos/Captures";
      };

      portal = {
        enable = true;
        config = {
          common.default = [
            "hyprland"
            "gtk"
          ];
          hyprland.default = [
            "hyprland"
            "gtk"
          ];
        };
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-hyprland
        ];
      };

      mime.enable = true;

      mimeApps = {
        defaultApplications = {
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
        };
      };
    };
  };
}
