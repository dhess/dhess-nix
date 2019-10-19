{ config
, pkgs
, lib
, ...
}:

with lib;

let
  cfg = config.services.jellyfin;
in
{
  disabledModules = [ "services/misc/jellyfin.nix" ];

  options = {
    services.jellyfin = {
      enable = mkEnableOption "the Jellyfin Media Server";

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/jellyfin";
        description = "The Jellyfin data directory.";
      };

      user = mkOption {
        type = types.str;
        default = "jellyfin";
        description = "User account under which Jellyfin runs.";
      };

      group = mkOption {
        type = types.str;
        default = "jellyfin";
        description = "Group under which Jellyfin runs.";
      };
    };
  };

  config = mkIf cfg.enable {
    dhess-nix.assertions.moduleHashes."services/misc/jellyfin.nix" =
      "69e79a42abc01dc141985a1d087d5cf499c287a7e4c759915fc8df1e08d8544b";

    systemd.services.jellyfin = {
      description = "Jellyfin Media Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = rec {
        User = cfg.user;
        Group = cfg.group;
        CacheDirectory = "jellyfin";
        ExecStart = "${pkgs.jellyfin}/bin/jellyfin --datadir '${cfg.dataDir}' --cachedir '/var/cache/${CacheDirectory}'";
        Restart = "on-failure";
      };
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0750 ${cfg.user} ${cfg.group} - -"
    ];

    users.users = mkIf (cfg.user == "jellyfin") {
      jellyfin.group = cfg.group;
    };

    users.groups = mkIf (cfg.group == "jellyfin") {
      jellyfin = {};
    };

  };

  meta.maintainers = with pkgs.lib.maintainers; [ dhess-pers ];
}
