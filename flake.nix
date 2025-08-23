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

        version = "0.0.1755979480";

        # These will be updated with actual SHA256 hashes by the workflow
        shaMap = {
          "linux-x64" = "7ed3d3f8c265c47f20eb9091a6cd9da7485ab7ad7d34cc030b0b647e1630af3c";
          "linux-arm64" = "a6c8816cbe80449c85b393f71c0add3e6730ca8e11f06de6053a579a5bafa575";
          "darwin-x64" = "4d36f06cd7c72c71d2b43e9209962fb449d3d1845adfe86f2674414429bc6f5c";
          "darwin-arm64" = "c55c737c18143798f8fe87b4a3f811eb4598c3af064a4eb1d17ceb0e6bdf0a8c";
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
