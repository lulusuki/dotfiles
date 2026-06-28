{
  nm.hyprland-config =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.wrappers.hyprland;

      hasStartup = cfg.startup != [ ];
      hasPlugins = cfg.plugins != [ ];

      toLua = lib.generators.toLua { };

      requireName = name: lib.removeSuffix ".lua" name;

      luaFileName = name: builtins.replaceStrings [ "." ] [ "/" ] (requireName name) + ".lua";

      autoLoadFiles = lib.filterAttrs (_: file: file.autoLoad) cfg.lua.files;

      # handle content being either a path or string
      toText = content: if builtins.isPath content then builtins.readFile content else content;

      pluginPath =
        entry:
        if lib.types.package.check entry then "${entry}/lib/lib${entry.pname}.so" else toString entry;

      startupSection = lib.concatStrings [
        (lib.optionalString (hasPlugins || hasStartup) ''
          hl.on("hyprland.start", function()
        '')
        (lib.optionalString hasPlugins ''
          ${cfg.plugins |> map (entry: "  hyprctl plugin load ${pluginPath entry}") |> lib.concatLines}
        '')
        (lib.optionalString hasStartup ''
          ${cfg.startup |> lib.concatMapStrings (command: "  hl.exec_cmd(${toLua command})\n")}
        '')
        (lib.optionalString (hasPlugins || hasStartup) ''
          end)
        '')
      ];

      hyprlandLua = lib.concatStrings [
        (lib.optionalString (cfg.lua.pre != "") ''
          -- wrappers.hyprland.lua.pre
          ${cfg.lua.pre}

        '')
        (lib.optionalString (hasStartup || hasPlugins) startupSection)
        (lib.optionalString (autoLoadFiles != { }) ''
          -- wrappers.hyprland.lua.files {autoLoad = true}
          ${
            autoLoadFiles |> lib.mapAttrsToList (name: _: ''require("${requireName name}")'') |> lib.concatLines
          }

        '')
        (lib.optionalString (cfg.lua.post != "") ''
          -- wrappers.hyprland.lua.post
          ${cfg.lua.post}

        '')
        ''
          -- dynamic code
          if utils.does_file_exist(os.getenv("HOME") .. "/.config/hypr/dynamic.lua") then
              require("dynamic")
          end
        ''
      ];

      luaConfigFiles =
        cfg.lua.files
        |> lib.mapAttrs' (
          fileName: file: {
            name = "hypr/${luaFileName fileName}";
            value.text = toText file.content;
          }
        );
    in
    {
      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          {
            environment.pathsToLink = [ "/share/hypr" ];

            security.wrappers.Hyprland = {
              owner = "root";
              group = "root";
              capabilities = "cap_sys_nice+ep";
              source = lib.getExe cfg.package;
            };

            xdg.portal = {
              enable = true;
              extraPortals = [
                pkgs.xdg-desktop-portal-hyprland
                pkgs.xdg-desktop-portal-gtk
              ];
              wlr.enable = false;
              configPackages = lib.mkDefault [ cfg.package ];
            };

            systemd.user.settings.Manager = {
              DefaultEnvironment = "PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH";
            };

            programs.xwayland.enable = cfg.withXwayland;
            programs.uwsm.enable = cfg.withUWSM;

            home-manager.sharedModules = [
              {
                _module.args.hyprlandCfg = cfg;
                _module.args.hyprlandLua = hyprlandLua;
                _module.args.hyprlandLuaConfigFiles = luaConfigFiles;
              }
            ];
          }

          (lib.mkIf cfg.withAutostart {
            programs.bash.interactiveShellInit =
              let
                session =
                  if cfg.withUWSM then
                    "exec uwsm start hyprland-uwsm.desktop"
                  else
                    lib.getExe' cfg.package "start-hyprland";
              in
              lib.mkOrder 0 ''
                if [[ $(tty) == '/dev/tty1' ]]; then
                  ${session}
                fi
              '';
          })

          (lib.mkIf cfg.withTermFileChooser {
            xdg.portal.config.hyprland = {
              default = lib.mkForce [
                "hyprland"
                "gtk"
              ];
              "org.freedesktop.impl.portal.FileChooser" = lib.mkForce [ "termfilechooser" ];
              "org.freedesktop.impl.portal.Secret" = lib.mkForce [ "gnome-keyring" ];
              "org.freedesktop.impl.portal.Chooser" = lib.mkForce [ "none" ];
            };
          })
        ]
      );

      _file = ./config.nix;
    };

  hm.hyprland =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      hyprlandCfg = config._module.args.hyprlandCfg or null;
      hyprlandLua = config._module.args.hyprlandLua or "";
      hyprlandLuaConfigFiles = config._module.args.hyprlandLuaConfigFiles or { };
    in
    lib.mkIf (hyprlandCfg != null) {
      xdg.configFile = lib.mkMerge [
        {
          "hypr/hyprland.lua".text = hyprlandLua;

          "hypr/.luarc.json".text = builtins.toJSON {
            workspace.library = [
              "${hyprlandCfg.package}/share/hypr/stubs"
            ];
          };

          "hypr/xdph.conf".text = ''
            screencopy {
                max_fps = 60
                allow_token_by_default = true
            }
          '';
        }
        hyprlandLuaConfigFiles
      ];

      home.packages = with pkgs; [
        slurp
        grim
        hyprlandCfg.package
      ];
    };
}
