# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755821877/amp-darwin-arm64.zip'
  sha256 '0e40a611b0fb18a4dd64cbad36b688ebd3aea7ea69a6d0ac6dfbf0a750575fce'
  version '0.0.1755821877'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755821877/amp-darwin-arm64.zip'
      sha256 '0e40a611b0fb18a4dd64cbad36b688ebd3aea7ea69a6d0ac6dfbf0a750575fce'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755821877/amp-darwin-x64.zip'
      sha256 'a646203e79465a638ffc5b2e3097c27d22316adba932c5455957eadfb30c719d'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755821877/amp-linux-arm64'
      sha256 '0fdfc43cc30aa4c0b8a35460d044ff590c755b886d36d6a769ef3a408c45fd76'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755821877/amp-linux-x64'
      sha256 'fb8bd2fb7ea7e4164f210e21683ad34f03641fec83b565e8e52a22a3da7ac2a1'
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
