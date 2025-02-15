# vim: set sw=2 et :
{config, lib, pkgs, inputs, myconf,...}:

{
  home.packages = (if myconf.hyprland.enable then with pkgs; [
      hyprland
      kitty
      feh
      #libnotify
      waybar
      #dunst
      #mako
      swww
      wofi
      swaylock
      swayidle
      networkmanagerapplet
      mesa-demos
      wlogout
    ] else []);

  programs.waybar = {
    enable = myconf.hyprland.enable;
    systemd.enable = true;
  };

  wayland.windowManager.hyprland = {
    systemd.enable = myconf.hyprland.enable && ! myconf.hyprland.withUWSM;
    package = config.lib.nixgl.wrap pkgs.hyprland;
  };

# programs.hyprland = {
#   enable = myconf.hyprland.enable;
#   nvidiaPatches = true;
#   xwayland.enable = true;
# };

  nixGL.packages = inputs.nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  nixGL.offloadWrapper = "nixGLNvidia";
  nixGL.installScripts = [ "mesa" "mesaPrime" "nvidiaPrime" ];
  nixGL.vulkan.enable = true;


  services =
    (if myconf.hyprland.enable then {
      copyq.enable = true;
      hyprpaper.enable = true;
      swayidle = let
        lockCommand = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
        dpmsCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms";
      in {
        enable = true;
        systemdTarget = "graphical-session.target";
        timeouts = [
          {
            timeout = 300;
            command = lockCommand;
          }
          {
            timeout = 600;
            command = "${dpmsCommand} off";
            resumeCommand = "${dpmsCommand} on";
          }
        ];
        events = [
          {
            event = "before-sleep";
            command = lockCommand;
          }
          {
            event = "lock";
            command = lockCommand;
          }
        ];
      };
      dunst.enable = false;
      mako.enable = false;
      swaync = {
        enable = true;
        style = ''
              .notification-row {
                outline: none;
              }

              .notification-row:focus,
              .notification-row:hover {
                background: @noti-bg-focus;
              }

              .notification {
                border-radius: 12px;
                margin: 6px 12px;
                box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.3), 0 1px 3px 1px rgba(0, 0, 0, 0.7),
                  0 2px 6px 2px rgba(0, 0, 0, 0.3);
                padding: 0;
              }
        '';
      };
    } else {});
}

