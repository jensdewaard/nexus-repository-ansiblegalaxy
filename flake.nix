{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      buildInputs = [
        pkgs.zulu8
        pkgs.maven
      ];
    in 
  {

    packages.x86_64-linux.nexus-repository-ansiblegalaxy = pkgs.maven.buildMavenPackage rec {
        inherit buildInputs;
        pname = "nexus-repository-ansiblegalaxy";
        version = "0.3.0";

        propagatedBuildInputs = [ ];

        src = self;

        mvnHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

        installPhase = ''
              mkdir -p $out/bin $out/share/nexus-repository-ansiblegalaxy
        '';
    };


    packages.x86_64-linux.default = self.packages.x86_64-linux.nexus-repository-ansiblegalaxy;

    devShell.x86_64-linux = pkgs.mkShell {
      inherit buildInputs;
    };
  };
}
