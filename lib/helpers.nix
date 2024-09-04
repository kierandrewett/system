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
        let
            pkgs = import inputs.nixpkgs {
                system = platform;
                config.allowUnfree = true;
            };
        in
        inputs.nixpkgs.lib.nixosSystem {
            specialArgs = {
                inherit inputs outputs username hostname platform desktop stateVersion;
            };

            modules = [
                inputs.home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.${username} = import ../home;
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