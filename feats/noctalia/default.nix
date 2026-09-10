{ inputs, ... }:

{
  flake.nixosModules.noctalia =
    { pkgs, ... }:
    let
      saveNoctalia = pkgs.writeShellApplication {
        name = "noctalia-save";
        runtimeInputs = with pkgs; [
          coreutils
          diffutils
          git
          yq-go
        ];
        text = ''
          repo="''${NH_FLAKE:-$HOME/nixos}"
          target="$repo/feats/noctalia/config.toml"
          temporary="$(mktemp)"
          filtered="$(mktemp)"
          trap 'rm -f "$temporary" "$filtered"' EXIT

          noctalia config export merged > "$temporary"
          yq --input-format toml --output-format toml \
            'del(.theme, .wallpaper, .shell.font_family,
              .calendar.account.proton)' \
            "$temporary" > "$filtered"
          noctalia config validate "$filtered"
          diff -u "$target" "$filtered" || true
          install -m 0644 "$filtered" "$target"
          echo "Updated $target"
        '';
      };
    in
    {
      fonts.packages = with pkgs; [
        noto-fonts-color-emoji
      ];

      home-manager.users.schphe = { lib, ... }: {
        imports = [ inputs.noctalia.homeModules.default ];
        home.activation.noctaliaStylixOwnership = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          state="$HOME/.local/state/noctalia/settings.toml"
          ${pkgs.coreutils}/bin/mkdir -p "$(${pkgs.coreutils}/bin/dirname "$state")"
          if [[ ! -f "$state" ]]; then
            ${pkgs.coreutils}/bin/install -m 0600 /dev/null "$state"
          fi
          if [[ -f "$state" ]]; then
            temporary="$(${pkgs.coreutils}/bin/mktemp)"
            ${pkgs.yq-go}/bin/yq --input-format toml --output-format toml \
              'del(.theme, .wallpaper, .shell.font_family,
                .calendar.account.proton)' \
              "$state" > "$temporary"
            if ! ${pkgs.diffutils}/bin/cmp -s "$state" "$temporary"; then
              ${pkgs.coreutils}/bin/install -m 0600 "$temporary" "$state"
            fi
            ${pkgs.coreutils}/bin/rm -f "$temporary"
          fi
          calendar_url="$(< /run/secrets/noctalia-calendar-url)" \
            ${pkgs.yq-go}/bin/yq --inplace \
              --input-format toml --output-format toml \
              '.calendar.account.proton = {
                "color": "primary",
                "name": "Schedule",
                "server_url": strenv(calendar_url),
                "type": "ics"
              }' \
              "$state"
        '';
        home.packages = with pkgs; [
          ddcutil
          grim
          kubectl
          less
          openssh
          saveNoctalia
          slurp
          (tesseract.override { enableLanguages = [ "eng" ]; })
          wl-color-picker
        ];
        programs.k9s.enable = true;

        programs.noctalia = {
          enable = true;
          systemd.enable = true;
          settings = builtins.fromTOML (builtins.readFile ./config.toml);
        };
      };
    };
}
