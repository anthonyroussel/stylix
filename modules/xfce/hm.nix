{ pkgs, config, lib, ... }@args:

let
  colors = config.lib.stylix.colors.withHashtag;

  themeFile = config.lib.stylix.colors {
    template = ./terminalrc.mustache;
    extension = "theme";
  };

in
{
  options.stylix.targets.xfce.enable =
    config.lib.stylix.mkEnableTarget "Xfce" true;

  config = lib.mkIf config.stylix.targets.xfce.enable {
    xfconf.settings = with config.stylix.fonts; {
      xfwm4 = {
        "general/title_font" = "${sansSerif.name} ${toString sizes.desktop}";
      };
      xsettings = {
        "Gtk/FontName" = "${sansSerif.name} ${toString sizes.applications}";
        "Gtk/MonospaceFontName" = "${monospace.name} ${toString sizes.applications}";
      };
    };


    home.file.".local/share/xfce4/terminal/colorschemes/stylix.theme".source = themeFile;

    xdg.configFile."xfce4/terminal/terminalrc".text = with config.stylix.fonts; ''
      [Configuration]
      ColorForeground=${colors.base05}
      ColorBackground=${colors.base00}
      ColorCursor=x
      ColorBoldIsBright=FALSE
      ColorPalette=${colors.base01};${colors.base08};${colors.base0B};${colors.base0A};${colors.base0D};${colors.base0F};${colors.base0C};${colors.base06};${colors.base00};${colors.base09};${colors.base02};${colors.base03};${colors.base04};${colors.base0E};${colors.base05};${colors.base07}
      FontName=${monospace.name} ${toString sizes.applications}
    '';
  };
}
