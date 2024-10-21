{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cpufetch
    ipfetch
    neofetch
    octofetch
    onefetch
    ramfetch
    starfetch
    htop
    bottom
    btop
    zfxtop
    kmon

    # vulkan-tools
    # opencl-info
    # clinfo
    # vdpauinfo
    # libva-utils
    # nvtop
    wlr-randr
    gpu-viewer
    dig
    speedtest-rs
  ];
}
