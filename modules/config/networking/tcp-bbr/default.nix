# Enable TCP BBR congestion control.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.quixops.networking.tcp-bbr;
  enabled = cfg.enable;

in
{
  options.quixops.networking.tcp-bbr = {
    enable = mkEnableOption "Enable TCP BBR congestion control.";
  };

  config = mkIf enabled {
    boot.kernelModules = [ "tcp_bbr" ];
    boot.kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";

    # see https://news.ycombinator.com/item?id=14814530
    boot.kernel.sysctl."net.core.default_qdisc" = "fq"; 
  };
}
