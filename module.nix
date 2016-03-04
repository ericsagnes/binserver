{ config, pkgs, lib ? pkgs.lib, ... }:

with lib;

let
  cfg = config.services.binserver;
  binserverPackage = (import ./release.nix);
in
{
  options = {
    services.binserver = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          run binserver service
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    
    environment.systemPackages = [ binserverPackage ];

    systemd.services.binserver = { 
      wantedBy = [ "multi-user.target" ];
      serviceConfig = { 
        ExecStart = "${binserverPackage}/bin/binserver";
        Restart = "always";
      };
    };
  };
}
