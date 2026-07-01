{
  withSystem,
  inputs,
  config,
  ...
}:
let
  nm = config.nm;
  hm = config.hm;
in
{
  flake.nixosConfigurations.lunar = withSystem "x86_64-linux" (
    { self', inputs', ... }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit self' inputs';
        hostname = "lunar";
      };
      modules = [
        inputs.home-manager.nixosModules.default
        nm.default
        nm.lunar
        hm.lunar
        nm.desktop
        nm.nvidia
      ];
    }
  );
}
