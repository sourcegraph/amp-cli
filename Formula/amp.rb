# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756181151/amp-darwin-arm64.zip'
  sha256 '2cbadd345de720c53a380ffaa8d9e9ca62ba7420dbf37595b6aac064e6635bc9'
  version '0.0.1756181151'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756181151/amp-darwin-arm64.zip'
      sha256 '2cbadd345de720c53a380ffaa8d9e9ca62ba7420dbf37595b6aac064e6635bc9'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756181151/amp-darwin-x64.zip'
      sha256 'efc97395bfc705c1456b226c69e6ec89ecad2275652c3c1c7037dc185418c33c'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756181151/amp-linux-arm64'
      sha256 '45ae3e5ee4ba178581636ad4d53be3e8cd6a8f6e80bdf91031f5bb1f6f476d39'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756181151/amp-linux-x64'
      sha256 '29083cdc74f18bca205e85d8370268ca1588c8ed9a1541889c0df91f99cc8b8a'
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
