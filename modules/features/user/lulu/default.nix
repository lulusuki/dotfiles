{ config, ... }:
let
  user = {
    name = "lulu";
    desc = "lulu";
    groups = [
      "networkmanager"
      "wheel"
    ];
  };
  flakeHomeModules = config.flake.homeModules;
in
{
  nm.default =
    {
      inputs,
      constants,
      ...
    }:
    {
      users.users.${user.name} = {
        isNormalUser = true;
        description = user.desc;
        extraGroups = user.groups;
        hashedPassword = "$6$MqJ/pq/ts0hM/jTe$4S8Ki/VjBps6OGuBonwvOrPZIWB3oXRKM9xpDWkhGzGwAonPNigndYG6aqd6HQH.z9LovZgonVFaY.ag/5E4N0";
      };

      home-manager = {
        extraSpecialArgs = { inherit inputs constants user; };
        useGlobalPkgs = true;
        useUserPackages = true;

        users.${user.name}.imports = [
          flakeHomeModules.${user.name}

          flakeHomeModules.hyprland
          flakeHomeModules.default
        ];
      };
    };
}
