# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756123674/amp-darwin-arm64.zip'
  sha256 'b86ec34a9d247453f9bd3c80d3b0f14c1b0bfc4e423f5dd3970edb2fcf83494b'
  version '0.0.1756123674'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756123674/amp-darwin-arm64.zip'
      sha256 'b86ec34a9d247453f9bd3c80d3b0f14c1b0bfc4e423f5dd3970edb2fcf83494b'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756123674/amp-darwin-x64.zip'
      sha256 'd001009d7f8e0c5b8e38145a8cf6bf1e788bce00f0f86684fe2e02c39564f24e'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756123674/amp-linux-arm64'
      sha256 'b6735a27b6c4cb5454364817a3d48af005fbea96fc8bc251547a6322c3c00182'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756123674/amp-linux-x64'
      sha256 '619ad6cfb42446738e5b47845fea97d9fbc21228c28308076e333a363dcf78f2'
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
