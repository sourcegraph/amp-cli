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

        version = "0.0.1756181151";

        # These will be updated with actual SHA256 hashes by the workflow
        shaMap = {
          "linux-x64" = "29083cdc74f18bca205e85d8370268ca1588c8ed9a1541889c0df91f99cc8b8a";
          "linux-arm64" = "45ae3e5ee4ba178581636ad4d53be3e8cd6a8f6e80bdf91031f5bb1f6f476d39";
          "darwin-x64" = "451955fe88d2099738431fd0e1a01712c8010c7ddbb55b5146a67e572c47ceee";
          "darwin-arm64" = "fbeee2bc69e289c5c36f4195be003acd329f80ad61bcbc64a1dfb84c74254c17";
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
