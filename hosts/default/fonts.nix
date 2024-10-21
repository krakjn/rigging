{ pkgs, ... }:

{
  # Fonts
  fonts.packages = with pkgs; [
    fira-code
    font-awesome
    jetbrains-mono
    maple-mono-NF
    nerd-font-patcher
    # nerdfonts
    noto-fonts
    noto-fonts-cjk
    terminus_font
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
