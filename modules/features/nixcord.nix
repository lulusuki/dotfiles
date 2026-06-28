{ inputs, ... }:
{
  inputs.nixcord.url = "github:FlameFlag/nixcord";

  hm.default = {
    imports = [ inputs.nixcord.homeModules.nixcord ];

    programs.nixcord = {
      vesktop.enable = true;
    };
  };
}
