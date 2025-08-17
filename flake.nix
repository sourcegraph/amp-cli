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

        version = "0.0.1755432418";

        # These will be updated with actual SHA256 hashes by the workflow
        shaMap = {
          "linux-x64" = "1e8e3d18808bb2a3a626f710332ba2348b4fbad4fd5dbfb69eadd6d2534fd718";
          "linux-arm64" = "b9051e413979c46b49bdf62f63bb6bcbf66d4341ab41a1f55a5ff9d576d3b801";
          "darwin-x64" = "e9ba939a80c82f1ec3f08164dafec9f5bab4151381574fd428ccff45073a0848";
          "darwin-arm64" = "3af32e8e412e7da4092e4915a9d2bbe10a17b78182d243983cf63fc55994fbee";
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
