{
  nm.desktop = {
    wrappers.hyprland.lua.pre = "utils = require('utils')";

    wrappers.hyprland.lua.files."utils" = {
      autoLoad = false;
      content = /* lua */ ''
        local utils = {}

        utils.does_file_exist = function(path)
          local f = io.open(path, "r")
          if f ~= nil then
            io.close(f)
            return true
          else
            return false
          end
        end

        return utils
      '';
    };
  };
}
