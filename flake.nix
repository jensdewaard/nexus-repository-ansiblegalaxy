{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in 
  {

    packages.x86_64-linux.nexus-repository-ansiblegalaxy = pkgs.stdenv.mkDerivation {
        pname = "nexus-repository-ansiblegalaxy";
        version = "0.3.0";

        buildInputs = [ pkgs.jdk8 pkgs.maven ];
        propagatedBuildInputs = [ ];

        src = self;

        buildPhase = ''
            mvn clean package -DbuildKar
        '';

        installPhase = ''
        '';
    };


    packages.x86_64-linux.default = self.packages.x86_64-linux.nexus-repository-ansiblegalaxy;

    devShell.x86_64-linux = pkgs.mkShell {
      buildInputs = with pkgs; [
        jdk8
        maven
      ];
    };
  };
}
