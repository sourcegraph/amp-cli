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

        version = "0.0.1754035600";

        # These will be updated with actual SHA256 hashes by the workflow
        shaMap = {
          "linux-x64" = "953bd1991e6baddd5025ad8c0c985d350dc808cc0c586c589d313e8302b43868";
          "linux-arm64" = "6bb51ffb56e7aa078932f65d4e9b419102c726caf098ffc1aa924af7595e36bd";
          "darwin-x64" = "dbe57d76d6c19322fbfe506af6d207577d98af41f5824161aeb8b4a3465de33b";
          "darwin-arm64" = "c98dc23b96f8abfd10a9c30e91cf4e2128ed00f4f1419f80109598b873f17e31";
        };

      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "amp";
          inherit version;

          src = pkgs.fetchurl {
            url = "https://github.com/sourcegraph/amp-cli/releases/download/v${version}/amp-${arch}";
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
            homepage = "https://github.com/sourcegraph/amp-cli";
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
