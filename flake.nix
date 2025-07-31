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

        version = "0.0.1753992324-g10d932";

        # These will be updated with actual SHA256 hashes by the workflow
        shaMap = {
          "linux-x64" = "500bfb66857ba6cc6e697f12512184fee2eb83477269e646bf05ff3dfca0e596";
          "linux-arm64" = "af8f55a35ebf6f76fec4f6f6d0d27c16625727231cc5884297b3a6a58184f77f";
          "darwin-x64" = "c54de14f742958d6650c71fd2461ede4f65f8e4e4318a1ea7f80af81e9ac1e5e";
          "darwin-arm64" = "f9d86d414936c4cf1ea4fb08aee1e0944674360e6728258432227cf4cff971d3";
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
