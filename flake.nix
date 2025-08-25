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

        version = "0.0.1756109231";

        # These will be updated with actual SHA256 hashes by the workflow
        shaMap = {
          "linux-x64" = "2918602957ee0c9b35492f1469f42687d6bfd7508f2b1f8257abb8a77979a031";
          "linux-arm64" = "e56aba7a54453d9b587200353495461660af6d98fbec23cca19bca0a3a60e23c";
          "darwin-x64" = "ab3639358fe4be80f0607f5022bf1574533ee5a3dc7944016d234b02c2704939";
          "darwin-arm64" = "cdc2ad1397fb3e2c2928a11c6748a7a5b4d15262efd2d54306daa349adbad4d0";
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
