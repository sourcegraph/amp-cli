# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754726736/amp-darwin-arm64.zip'
  sha256 'eb26ae4270aecbf9f282a14ecab2c191bc9ce6353a9e218ed54cca81a1de9e49'
  version '0.0.1754726736'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754726736/amp-darwin-arm64.zip'
      sha256 'eb26ae4270aecbf9f282a14ecab2c191bc9ce6353a9e218ed54cca81a1de9e49'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754726736/amp-darwin-x64.zip'
      sha256 '079a7dabb6e230264a3bdcb1afaab12e282df7c2af1219fa0990e1c5b2b1f66d'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754726736/amp-linux-arm64'
      sha256 'e559f6abb7efa4c43f0f2fda8992b8a2c481b4e232ca3ddd32d8979c532d9033'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754726736/amp-linux-x64'
      sha256 '1fa23d80aff850a9767fd83c76fc71d57f201e8fb0220fae3bac5900baab2486'
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
