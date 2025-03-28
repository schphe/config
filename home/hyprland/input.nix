{...}: {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
  
    bind = [
      "$mod, P, exec, hyprpicker -al"

      "$mod,            Q, killactive,"
      "$mod+CTRL+SHIFT, Q, exit,"

      "$mod,       F, fullscreen, 0"
      "$mod+SHIFT, F, togglefloating,"

      "$mod, left , movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up   , movefocus, u"
      "$mod, down , movefocus, d"

      "$mod+SHIFT, E, movetoworkspace, empty"
      "$mod,       1, workspace, 1"
      "$mod+SHIFT, 1, movetoworkspacesilent, 1"
      "$mod,       2, workspace, 2"
      "$mod+SHIFT, 2, movetoworkspacesilent, 2"
      "$mod,       3, workspace, 3"
      "$mod+SHIFT, 3, movetoworkspacesilent, 3"
      "$mod,       4, workspace, 4"
      "$mod+SHIFT, 4, movetoworkspacesilent, 4"
      "$mod,       5, workspace, 5"
      "$mod+SHIFT, 5, movetoworkspacesilent, 5"
      "$mod,       6, workspace, 6"
      "$mod+SHIFT, 6, movetoworkspacesilent, 6"
      "$mod,       7, workspace, 7"
      "$mod+SHIFT, 7, movetoworkspacesilent, 7"
      "$mod,       8, workspace, 8"
      "$mod+SHIFT, 8, movetoworkspacesilent, 8"
      "$mod,       9, workspace, 9"
      "$mod+SHIFT, 9, movetoworkspacesilent, 9"
      "$mod,       0, workspace, 10"
      "$mod+SHIFT, 0, movetoworkspacesilent, 10"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    gestures = {
      workspace_swipe = true;
    };

    input = {
      kb_layout = "tr";

      touchpad = {
        clickfinger_behavior = true;
        disable_while_typing = false;
        natural_scroll = true;
        tap-to-click = false;
      };
    };
  };
}
