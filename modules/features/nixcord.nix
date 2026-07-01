{ inputs, ... }:
{
  inputs.nixcord.url = "github:FlameFlag/nixcord";

  hm.default = {
    imports = [ inputs.nixcord.homeModules.nixcord ];

    programs.nixcord = {
      enable = true;

      vesktop.enable = true;
      discord.vencord.enable = true;
    };
  };
}
