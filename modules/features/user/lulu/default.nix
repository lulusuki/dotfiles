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
        password = "changeme";
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
