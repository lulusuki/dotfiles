{
  withSystem,
  inputs,
  config,
  ...
}:
let
  nm = config.nm;
in
{
  flake.nixosConfigurations.solar = withSystem "x86_64-linux" (
    { self', inputs', ... }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit self' inputs';
      };
      modules = [
        inputs.home-manager.nixosModules.default
        nm.default
        nm.solar
        nm.desktop
        nm.nvidia
      ];
    }
  );
}
