{ inputs, ... }:
{
  inputs.hyprland.url = "github:hyprwm/Hyprland/tags/v0.55.4";

  nm.desktop = { pkgs, ... }: {
    wrappers.hyprland.enable = true;

    wrappers.hyprland.package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

    wrappers.hyprland.lua.files."general".content = /* lua */ ''
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

      -------------------
      -- General Looks --
      -------------------

      hl.config({
        general = {
          border_size = 1,
          gaps_out = 8,
          layout = "scrolling",
        },

        decoration = {
          rounding = 8,

          blur = {
            enabled = true,

            xray = true,

            noise = 0.05
          }
        },
      })

      -------------------
      -- Window Layout --
      -------------------
      hl.config({
        scrolling = {
          fullscreen_on_one_column = false,
          column_width = 0.5,
          explicit_column_widths = "0.333, 0.5, 0.667, 1.0"
        },
      })

      -----------------------
      -- Window Workspaces --
      -----------------------

      -- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
      -- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

      -- local suppressMaximizeRule = hl.window_rule({
      --   Ignore maximize requests from all windows by default
      --   name = "suppress-maximize-events",
      --   match = { class = ".*" },
      --
      --   suppress_event = "maximize",
      -- })

      local ghosttyGhosting = hl.window_rule({
        name = "ghostty-ghosting",
        match = { class = "com.mitchellh.ghostty" },
      })

      hl.window_rule({
        -- Fix some dragging issues with XWayland
        name = "fix-xwayland-drags",
        match = {
          class = "^$",
          title = "^$",
          xwayland = true,
          float = true,
          fullscreen = false,
          pin = false,
        },

        no_focus = true,
      })

      hl.window_rule({
        name = "no-screen-share-firefox",
        match = {
          class = "firefox"
        },

        no_screen_share = true
      })

      hl.window_rule({
        name = "screen-share-popup-center",
        match = {
          title = "Select what to share"
        },

        float = true,
        center = true,
      })

      ---------------
      -- Autostart --
      ---------------

      hl.on("hyprland.start", function()
        -- hl.exec_cmd("waybar")
      end)
    '';
  };
}
