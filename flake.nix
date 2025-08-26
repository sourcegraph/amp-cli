{
  description = "Amp CLI - An agentic coding tool, in research preview from Sourcegraph";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Map system to release architecture
        archMap = {
          "x86_64-linux" = "linux-x64";
          "aarch64-linux" = "linux-arm64";
          "x86_64-darwin" = "darwin-x64";
          "aarch64-darwin" = "darwin-arm64";
        };

        arch = archMap.${system} or (throw "Unsupported system: ${system}");

        version = "0.0.1756167489";

        # These will be updated with actual SHA256 hashes by the workflow
        shaMap = {
          "linux-x64" = "9ea940252f5c395839821908dbc059d7e1cb72bb4bfc8380a504997ddf58d00e";
          "linux-arm64" = "2b0f26f7ee03362f16f6b68fb735ffb02bcb37dae5fbe955c2dee4ced45659cf";
          "darwin-x64" = "ec8d86103d034b0e6114757216fa71c300e55505f02fc8160f7547550a2cabec";
          "darwin-arm64" = "b1630f2a5b9b9d8b398441be79250ddac740b479687aa92491cf620b66d5c278";
        };

      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "amp";
          inherit version;

          src = pkgs.fetchurl {
            url = "https://packages.ampcode.com/binaries/cli/v${version}/amp-${arch}";
            sha256 = shaMap.${arch};
          };

          buildInputs = [ ];

          dontBuild = true;
          dontConfigure = true;
          dontUnpack = true;
          dontStrip = true;

          installPhase = ''
            runHook preInstall

            mkdir -p $out/bin
            cp $src $out/bin/amp
            chmod +x $out/bin/amp

            # Create wrapper to ensure ripgrep is in PATH
            wrapProgram $out/bin/amp \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.ripgrep ]}

            runHook postInstall
          '';

          nativeBuildInputs = [ pkgs.makeWrapper ];

          meta = with pkgs.lib; {
            description = "An agentic coding tool, in research preview from Sourcegraph";
            homepage = "https://ampcode.com";
            license = licenses.mit;
            maintainers = [ ];
            platforms = platforms.unix;
          };
        };

        # Alias for convenience
        packages.amp = self.packages.${system}.default;

        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Add any development dependencies here
          ];
        };

        # App definition for `nix run`
        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/amp";
        };
      });
}
