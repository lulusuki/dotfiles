{
  hm.default =
    {
      pkgs,
      ...
    }:
    {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
          nrsf = "sudo nixos-rebuild switch --flake";
        };

        setOptions = [
          "AUTO_CD"
        ];

        initContent = ''
          source ~/.p10k.zsh
          eval "$(zoxide init zsh)"
        '';
        plugins = [
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
        ];
      };
    };
}
