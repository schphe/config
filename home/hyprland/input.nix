{...}: {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
  
    bind = [
      "$mod, Q, killactive,"

      "$mod,       F, fullscreen, 0"
      "$mod+SHIFT, F, togglefloating,"
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
