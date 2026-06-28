{
  nm.solar =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        vim
        wget
        git
      ];
    };
}
