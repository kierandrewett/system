{
    lib,
    config,
    ...
}:
{
    hardware.enableRedistributableFirmware = lib.mkForce true;

    # Apply microcode firmware updates wherever possible
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}