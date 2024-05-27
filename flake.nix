{
  description = "nimgen";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      allSystems = [ "x86_64-linux" ];
      forAllSystems = fn:
        nixpkgs.lib.genAttrs allSystems
	(system: fn {pkgs = import nixpkgs { inherit system; }; });

    in

    {
  
      packages = forAllSystems ({ pkgs }: {
        default = pkgs.stdenv.mkDerivation {
	  name = "nimgen";
	  src = self;
	  nativeBuildInputs = [ pkgs.nim2 ];
	  buildPhase = "nim c -d:release -o:nimgen --nimcache:nimcache ./src/nimgen.nim";
	  installPhase = "mkdir -p $out/bin; install -t $out/bin nimgen";

	};
      });
        
  
      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell {
          name = "nimgen dev";
          nativeBuildInputs = [ pkgs.nim2 ];
        };
      });
    };
}
