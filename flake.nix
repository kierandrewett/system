{
    description = "Kieran's Nix configuration";

    inputs = {
        # Nixpkgs
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        # Home manager
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        # NixOS hardware support
        nixos-hardware.url = "github:NixOS/nixos-hardware";

        # SOPS secrets
        sops-nix.url = "github:Mic92/sops-nix";

        # Disko
        disko.url = "github:nix-community/disko";
        disko.inputs.nixpkgs.follows = "nixpkgs";

        # Firefox Nightly
        firefox-nightly.url = "github:nix-community/flake-firefox-nightly";
        firefox-nightly.inputs.nixpkgs.follows = "nixpkgs";

        # NUR
        nur.url = "github:nix-community/nur";

        # VSCode extensions
        vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

        # VSCode extensions
        nixpkgs-spotify.url = "github:nixos/nixpkgs/1b7a6a6e57661d7d4e0775658930059b77ce94a4";
    };

    outputs =
        {
            self,
            nixpkgs,
            ...
        }@inputs:
        let
            inherit (self) outputs;

            # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
            stateVersion = "24.05";

            helpers = import ./lib/helpers.nix { inherit inputs outputs stateVersion; };
        in
        {
            nixosConfigurations = {
                # Main PC
                fsociety = helpers.mkSystem {
                    type = "desktop";
                    hostname = "fsociety";
                    username = "kieran";
                    desktop = "gnome";
                    graphics = "amd";
                };
                # Lenovo IdeaPad Slim 5
                ssociety = helpers.mkSystem {
                    type = "laptop";
                    hostname = "ssociety";
                    username = "kieran";
                    desktop = "gnome";
                    graphics = "amd";
                };
                # Test VM
                testvm = helpers.mkSystem {
                    type = "desktop";
                    hostname = "testvm";
                    username = "kieran";
                    desktop = "gnome";
                };
            };

            packages = helpers.forAllSystems (system: nixpkgs.legacyPackages.${system});
        };
}
