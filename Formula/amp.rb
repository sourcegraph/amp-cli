# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754195001/amp-darwin-arm64.zip'
  sha256 'b0c86adc69007533c020f712ef799d63df1b519cf72032f5c73181f9b7360ad5'
  version '0.0.1754195001'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754195001/amp-darwin-arm64.zip'
      sha256 'b0c86adc69007533c020f712ef799d63df1b519cf72032f5c73181f9b7360ad5'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754195001/amp-darwin-x64.zip'
      sha256 '9e37f0d4fefc52282ab698e602966fba8b40b1d7d526f60b8366cf1913070296'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754195001/amp-linux-arm64'
      sha256 'bf4e72b9dcf8da7ab02cafb0e9aaa29ec7515d54582060791cdc2982b539521c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754195001/amp-linux-x64'
      sha256 '9bc52fdf706f582725a6894ddab0b3056c1e97b8a65a389d8aea4bcb764922b4'
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
