{
  description = "Amp CLI - AI-powered coding assistant";

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

        version = "0.0.1753984723-gda0d4e";

        # These will be updated with actual SHA256 hashes by the workflow
        shaMap = {
          "linux-x64" = "cb8dbff18352e93e7650536ac8f5652b593d404ac76227da3bddb5d5353066c5";
          "linux-arm64" = "36e31cb5a28b4f26f1ac6aad02737af7e5772037d1bb1a0a562bf54991848fa7";
          "darwin-x64" = "a68adc8016872e050e4120db195b292f54e98852bbf71df6edd75f136b0a5ab1";
          "darwin-arm64" = "d01d16b0de17821a45a6b7087940262f179c6b91751cd69f0f11fd2d48934af8";
        };

      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "amp";
          inherit version;

          src = pkgs.fetchurl {
            url = "https://github.com/sourcegraph/amp-packages/releases/download/v${version}/amp-${arch}";
            sha256 = shaMap.${arch};
          };

          buildInputs = [ pkgs.ripgrep ];

          dontBuild = true;
          dontConfigure = true;
          dontUnpack = true;

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
            description = "AI-powered coding assistant CLI tool";
            homepage = "https://github.com/sourcegraph/amp-packages";
            license = licenses.mit; # Update with actual license
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
