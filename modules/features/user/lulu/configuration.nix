{
  hm.lulu =
    {
      constants,
      user,
      pkgs,
      ...
    }:
    {
      home = {
        stateVersion = constants.stateVersion;
        username = user.name;
        homeDirectory = "/home/${user.name}";

        pointerCursor = {
          name = "Bibata-Modern-Ice";
          package = pkgs.bibata-cursors;
          size = 24;
          gtk.enable = true;
        };

        sessionVariables = {
          EDITOR = "nvim";
        };
      };
    };
}
