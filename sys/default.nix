{
    inputs,
    username,
    hostname,
    platform,
    desktop,
    stateVersion ? null,
    lib,
    config,
    pkgs,
    ...
}:
{
    imports = [
        inputs.sops-nix.nixosModules.sops
        inputs.disko.nixosModules.disko

        ./apps/all.nix
        ./machines/${hostname}
        ./desktop/${desktop}
        ./features
        ./users
    ];

    # These packages are absolutely essential
    # and will be required on all machines!
    environment.systemPackages = with pkgs; [
        git
        pciutils
        nix-prefetch
    ];

    sops = {
        age = {
            keyFile = "/home/${username}/.config/sops/age/key.txt";
            generateKey = false;
        };

        defaultSopsFile = ../secrets/secrets.yaml;

        secrets = {
            "luks/passphrase" = {};

            "users/${username}/passwd" = {};

            "networks/vm/ssid" = {};
            "networks/vm/psk" = {};

            "sync/nc/url" = {};
            "sync/nc/username" = {};
        };

        templates = {
            "wifi/vm.env" = {
                content = ''
                    SSID = "${config.sops.placeholder."networks/vm/ssid"}"
                    PSK = "${config.sops.placeholder."networks/vm/psk"}"
                '';
            };
        };
    };
}