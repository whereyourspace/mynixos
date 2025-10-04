{
  description = "My NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, home-manager, nixpkgs, ... }@inputs:
  let
    hostname = "space";
    username = "space";
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    inherit (self) outputs;
  in
  {
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs outputs username hostname; };
      modules = [ ./nixos/configuration.nix ];
    };
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit username; };
      modules = [ ./home-manager/home.nix ];
    };

    devShells.${system} = 
      let
        registries-conf = pkgs.writeText "registries-configs" ''
          [registries.search]
          registries = [ 'docker.io' ]

          [registries.block]
          registries = [ ]
        '';
        policy-json = pkgs.writeText "policy-configs" ''
          {
            "default": [
                {
                    "type": "insecureAcceptAnything"
                }
            ],
            "transports":
                {
                    "docker-daemon":
                        {
                            "": [{"type":"insecureAcceptAnything"}]
                        }
                }
          }
        '';
        default-shell = pkgs.mkShell {
          name = "${username}-default-shell";

          buildInputs = with pkgs; [
            fzf
            git
            podman
            dive
            btop-cuda
            tree     
          ];

          shellHook = ''
            if [ ! -f ~/.config/containers/registries.conf ]; then
              mkdir -p ~/.config/containers
              ln -sf ${registries-conf} ~/.config/containers/registries.conf
            fi

            if [ ! -f ~/.config/containers/policy.json ]; then
              mkdir -p ~/.config/containers
              ln -sf ${policy-json} ~/.config/containers/policy.json
            fi
          '';          
        };

       software-engineer = pkgs.mkShell {
          packages = with pkgs; [
            # C++ development tools
            cmake
            gcc15
            conan

            # go development tools
            go
            go-outline
            gopkgs
            go-tools
            delve

            # rust development tools
            rustup

            # python development tools
            python313
            python313Packages.pip
            poetry
            hatch
          ];
        };

        system-engineer = pkgs.mkShellNoCC {
          packages = with pkgs; [
            # IaC tools

            ## k8s
            kubectl

            ## ansible
            ansible
            python313
            python313Packages.pip

            ## terraform
            tenv

            ## pulumi
            pulumi

            ## network diagnostic
            traceroute
            mtr
            tcpdump
            wireshark
            dig
            iproute2
          ];
        };
      in
      {
        default = pkgs.mkShell {
          name = "default";
          inputsFrom = [
            default-shell
          ];
        };

        software-engineer = pkgs.mkShell {
          name = "software-engineer-shell";
          inputsFrom = [
            default-shell
            software-engineer
          ];
        };

        system-engineer = pkgs.mkShell {
          name = "system-engineer-shell";
          inputsFrom = [
            default-shell
            system-engineer
          ];
        };
      };
    };
}

