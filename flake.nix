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

        version = "0.0.1753977981-g14e5bc";

        # These will be updated with actual SHA256 hashes by the workflow
        shaMap = {
          "linux-x64" = "399ad29e5bf8ff908a4004e6deda73ac35bb3e12acd364cd6e170f38059d68a9";
          "linux-arm64" = "49cd2f32841e02de6b29f0a23d226208cadd099b143fa3488321dc8f7d2c2192";
          "darwin-x64" = "73c1e9b46aba31ce2ff938b2d5d19a01d76338241b40cfa225a11d9d88761e77";
          "darwin-arm64" = "819e893b8eec9ba3240f93ff231a96fe471f183844be3cd02b2c4b4c9cfe8225";
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
