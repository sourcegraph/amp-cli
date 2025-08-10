# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754827641/amp-darwin-arm64.zip'
  sha256 '7d0e53e0cdc8a842d5938a0631357995bad6514d4a04e07db1379ab0c4db0017'
  version '0.0.1754827641'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754827641/amp-darwin-arm64.zip'
      sha256 '7d0e53e0cdc8a842d5938a0631357995bad6514d4a04e07db1379ab0c4db0017'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754827641/amp-darwin-x64.zip'
      sha256 '8f40f010f996315f1709a09d21eb58569df92554e3ddc3934be231c30abc6781'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754827641/amp-linux-arm64'
      sha256 '760c8cb2a94b3e7e993de0b4ca475153ffce6750f84e56f1418db3fe7cb7bfbf'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754827641/amp-linux-x64'
      sha256 '45460563d6abb413ec50addcc4d6c74e4488ea83d7660b4ac254f2e44776dd8a'
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
