{
  nm.lunar =
    { pkgs, ... }:
    {
      environment.etc.issue.source = pkgs.writeText "etc/issue" ''
               \`*-.
                )  _`-.
               .  : `. .
               : _   '  \
               ; *` _.   `*-._
               `-.-'          `-.
                 ;       `       `.
                 :.       .        \
                 . \  .   :   .-'   .
                 '  `+.;  ;  '      :
                 :  '  |    ;       ;-.
                 ; '   : :`-:     _.`* ;
        [bug] .*' /  .*' ; .*`- +'  `*'
              `*-*   `*-*  `*-*'␍
      '';

      boot = {
        loader = {
          systemd-boot = {
            enable = true;
            configurationLimit = 4;
            editor = false;
          };
          efi.canTouchEfiVariables = true;
        };

        initrd.systemd.enable = true;
        consoleLogLevel = 3;
        loader.timeout = 1;
        kernelParams = [
          "quiet"
          "udev.log_level=3"
          "systemd.show_status=auto"
        ];
      };
    };
}
