# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754266918/amp-darwin-arm64.zip'
  sha256 'fdfb512573dd9ee34fa9f80054f4fa3f42fdf3fdd82e749a6d5a3acdec37cd75'
  version '0.0.1754266918'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754266918/amp-darwin-arm64.zip'
      sha256 'fdfb512573dd9ee34fa9f80054f4fa3f42fdf3fdd82e749a6d5a3acdec37cd75'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754266918/amp-darwin-x64.zip'
      sha256 '8536bb310031b5b0178b0320c2f4cd06132f630406ae208302de3cc2485fbf9d'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754266918/amp-linux-arm64'
      sha256 'd788c8b30e2f8d3e0fc8b11530093e21fe40ece0d63b70b8543ec58b8a89471c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754266918/amp-linux-x64'
      sha256 'f35c28bce064c0344e8b06f13bf45a3248d0a2df47ca12a3e1a1399667728aca'
    end
  end

  depends_on 'ripgrep'

  def install
    # Determine binary based on platform and architecture
    platform = OS.mac? ? 'darwin' : 'linux'
    arch = Hardware::CPU.arm? ? 'arm64' : 'x64'
    binary_name = "amp-#{platform}-#{arch}"

    bin.install binary_name => 'amp'
  end

  test do
    system "#{bin}/amp", '--version'
  end
end
