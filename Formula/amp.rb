# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754223932/amp-darwin-arm64.zip'
  sha256 'f7cb35e4bb08d3c24399ebed179f23a06068dbe67192d6b7e6bbcfe3a906e803'
  version '0.0.1754223932'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754223932/amp-darwin-arm64.zip'
      sha256 'f7cb35e4bb08d3c24399ebed179f23a06068dbe67192d6b7e6bbcfe3a906e803'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754223932/amp-darwin-x64.zip'
      sha256 '2d3e4aaf355977c1016aadc8518a61fa762d219ca2722289523b08cd7f212068'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754223932/amp-linux-arm64'
      sha256 'db9fb818b6ef8a85317b123f467b931856501622f357ae80cec07fdb1377c804'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754223932/amp-linux-x64'
      sha256 'd3c367e3038f7c26c50ebc2ba3dd107e1ca6f1e05d6db6d1ffe9fae6c7e26ec0'
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
