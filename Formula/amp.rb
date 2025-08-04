# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754281654/amp-darwin-arm64.zip'
  sha256 'ca632ed1b7a2ad6fb984509d6ba55a26f6308f81b341ca62d0cff21dcba7c0e6'
  version '0.0.1754281654'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754281654/amp-darwin-arm64.zip'
      sha256 'ca632ed1b7a2ad6fb984509d6ba55a26f6308f81b341ca62d0cff21dcba7c0e6'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754281654/amp-darwin-x64.zip'
      sha256 'ef23f45e4bd975f2b2b0ded20496119a35bbb4a7d03168c20eea9960423c5796'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754281654/amp-linux-arm64'
      sha256 'b174cb230c94be30bb1b16ba1a218144816ef2ba5f3e990753139acf1a7f2d83'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754281654/amp-linux-x64'
      sha256 '11569b52517a9a1c78b820701b301266291dea2aa2c71c955ab169d61c708a2d'
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
