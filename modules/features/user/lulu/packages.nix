{
  hm.lulu = { pkgs, ...}: {
    home.packages = with pkgs; [
      # Development
      godotPackages_4_6.godot-mono
      lazygit
    ];
  };
}
