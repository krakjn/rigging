{ ... }: {
  imports = [
    ../../modules/vm-guest-services.nix
    ../../modules/drivers/amd.nix
    ../../modules/drivers/nvidia.nix
    ../../modules/drivers/nvidia-prime.nix
    ../../modules/drivers/intel.nix
  ];

  # OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Extra Module Options
  drivers.amdgpu.enable = true;
  drivers.intel.enable = true;
  drivers.nvidia.enable = false;
  drivers.nvidia-prime = {
    enable = false;
    intelBusID = "";
    nvidiaBusID = "";
  };
}
