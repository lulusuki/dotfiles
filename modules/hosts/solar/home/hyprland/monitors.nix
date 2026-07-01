{
  nm.solar = {
    wrappers.hyprland.lua.files."monitors".content = /* lua */ ''
      hl.monitor({
        output = "DP-3",
        mode = "2560x1440@120.00",
        position = "0x0",
        scale = 1
      })

      hl.monitor({
        output = "DP-4",
        mode = "2560x1440@120.00",
        position = "2560x0",
        scale = 1,
      })
    '';
  };
}
