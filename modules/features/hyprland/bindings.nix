{
  nm.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [
      kitty
      hyprlauncher
      yazi
    ];

    wrappers.hyprland.lua.files."bindings".content = /* lua */ ''
      local terminal = "kitty"
      local fileManager = "kitty -e yazi"
      local menu = "hyprlauncher"

      local mainMod = "SUPER"

      hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(opts.terminal))
      hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(opts.fileManager))
      hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(opts.menu))

      hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mainMod .. " + C", hl.dsp.window.close())

      for i = 1, 5 do
        hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
        hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
      end

      -- Move focus with keys
      hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
      hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
      hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
      hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

      -- hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
      -- hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
      -- hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
      -- hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

      hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

      -- Move/resize windows with mouse
      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- Laptop audio/brightness controls
      hl.bind(
        "XF86AudioRaiseVolume",
        hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
        { locked = true, repeating = true }
      )
      hl.bind(
        "XF86AudioLowerVolume",
        hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
        { locked = true, repeating = true }
      )
      hl.bind(
        "XF86AudioMute",
        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
        { locked = true, repeating = true }
      )
      hl.bind(
        "XF86AudioMicMute",
        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
        { locked = true, repeating = true }
      )
      hl.bind(
        "XF86MonBrightnessUp",
        hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),
        { locked = true, repeating = true }
      )
      hl.bind(
        "XF86MonBrightnessDown",
        hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
        { locked = true, repeating = true }
      )

      -- Scrolling binds
      hl.bind(mainMod .. " + comma", hl.dsp.layout("colresize -conf"))
      hl.bind(mainMod .. " + period", hl.dsp.layout("colresize +conf"))

      hl.bind(mainMod .. " + bracketleft", hl.dsp.window.move({ direction = "left", group_awate = true }))
      hl.bind(mainMod .. " + bracketright", hl.dsp.window.move({ direction = "right", group_awate = true }))

      hl.bind(mainMod .. " + SHIFT + bracketleft", hl.dsp.layout("swapcol l"))
      hl.bind(mainMod .. " + SHIFT + bracketright", hl.dsp.layout("swapcol r"))

      hl.bind(mainMod .. " + P", hl.dsp.layout("consume_or_expel prev"))
      hl.bind(mainMod .. " + SHIFT + P", hl.dsp.layout("consume_or_expel next"))
    '';
  };
}
