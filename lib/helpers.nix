{
    inputs,
    outputs,
    stateVersion,
    ...
}:
{
    mkSystem =
        {
            hostname,
            desktop,
            username,
            platform ? "x86_64-linux",
        }:
        inputs.nixpkgs.lib.nixosSystem {
            system = platform;

            specialArgs = {
                inherit inputs outputs username hostname platform desktop stateVersion;
            };

            modules = [
                ../lib/nix-config.nix

                inputs.home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.${username}.imports = [../home];
                    home-manager.extraSpecialArgs.inputs = inputs;
                }

                ../sys
            ];
        };

    forAllSystems = inputs.nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
    ];
}