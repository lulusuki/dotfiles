{
  nm.desktop = {
    wrappers.hyperland.enable = true;

    wrappers.hyprland.lua.files."general".conent = /* lua */ ''
      hl.monitor({
      	output = "",
      	mode = "preferred",
      	position = "auto",
      	scale = "1",
      })

      -- Capture card
      hl.monitor({
      	output = "desc:Integrated Tech Express Inc ITE6802",
      	mirror = "eDP-2",
      })
    '';
  };
}
