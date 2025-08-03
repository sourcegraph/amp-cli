# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754237107/amp-darwin-arm64.zip'
  sha256 'b46c2237e0d6efab700814993cee8fec9845dee42c58ee2ca5e46aa0faf86080'
  version '0.0.1754237107'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754237107/amp-darwin-arm64.zip'
      sha256 'b46c2237e0d6efab700814993cee8fec9845dee42c58ee2ca5e46aa0faf86080'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754237107/amp-darwin-x64.zip'
      sha256 'eb320e8e9bc838cb783822b46f073f26dc752097d4f70294fc2e3bf5217db246'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754237107/amp-linux-arm64'
      sha256 'dc6c25d3ba721d8a3c56deddce14cdaba4b70e8e5a6c885b26da4ca80edf9c14'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754237107/amp-linux-x64'
      sha256 '90c4843ea048b192d1899636135fcdf1f7c5f5e6a98f161d408a0c54d127f49e'
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
