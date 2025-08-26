# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756167489/amp-darwin-arm64.zip'
  sha256 'ec7b3c72962b3577204c3be2d759d33464db82afc59befb16b080994040edfc6'
  version '0.0.1756167489'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756167489/amp-darwin-arm64.zip'
      sha256 'ec7b3c72962b3577204c3be2d759d33464db82afc59befb16b080994040edfc6'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756167489/amp-darwin-x64.zip'
      sha256 '7beb798c5cd9605ac523ce9b242a8a9ae5dca35eec7fb0a2306ff5336785e4cd'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756167489/amp-linux-arm64'
      sha256 '2b0f26f7ee03362f16f6b68fb735ffb02bcb37dae5fbe955c2dee4ced45659cf'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756167489/amp-linux-x64'
      sha256 '9ea940252f5c395839821908dbc059d7e1cb72bb4bfc8380a504997ddf58d00e'
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
