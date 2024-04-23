{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      jdk8 = pkgs.zulu8;
      mavenJdk8 = pkgs.maven.override {
        jdk = jdk8;
      };
      buildInputs = [
        jdk8
        mavenJdk8
      ];
    in 
  {

    packages.x86_64-linux.nexus-repository-ansiblegalaxy = mavenJdk8.buildMavenPackage rec {
        pname = "nexus-repository-ansiblegalaxy";
        version = "0.3.0";

        src = self;

        mvnHash = "sha256-XynT6FBTj865t/mIjZMVtcsGiSmLCd1ZpTeaMpDARaQ=";

        mvnParameters = "-PbuildKar";
        
        installPhase = ''
          mkdir -p $out/share/
          cp nexus-repository-ansiblegalaxy/target/*.jar $out/share/
          cp nexus-repository-ansiblegalaxy/target/*.kar $out/share/
        '';
    };


    packages.x86_64-linux.default = self.packages.x86_64-linux.nexus-repository-ansiblegalaxy;

    devShell.x86_64-linux = pkgs.mkShell {
      inherit buildInputs;
    };
  };
}
