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

        version = "0.0.1753987260-gda0d4e";

        # These will be updated with actual SHA256 hashes by the workflow
        shaMap = {
          "linux-x64" = "f5b611c471c5487e9004173aee93f26c777aee351de2a4aceaf1d947be2b7d4a";
          "linux-arm64" = "075491b8ebf0145dfa8f925ec338c158ec45d82ea105c95325d35964896b44b6";
          "darwin-x64" = "33f56c581bbfc7bea84b6127dd614f2ef362730635ba2c115ac82a66f348c26b";
          "darwin-arm64" = "db7a96f9d1a4f34003a85f3970f63c8724fea4b30ea0adfffbc1963c36798709";
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
