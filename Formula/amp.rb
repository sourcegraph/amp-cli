# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754424340/amp-darwin-arm64.zip'
  sha256 '6d3c73fc56f4eb1e8e23bbb50f73be08d6805901120c30b58bf5cf7dd53f6200'
  version '0.0.1754424340'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754424340/amp-darwin-arm64.zip'
      sha256 '6d3c73fc56f4eb1e8e23bbb50f73be08d6805901120c30b58bf5cf7dd53f6200'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754424340/amp-darwin-x64.zip'
      sha256 '8cf7ddc5c06b5a616d070e0209d98b927d417a3a1e100ee57a2fdb6daba8fd86'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754424340/amp-linux-arm64'
      sha256 '46b0a234cbb60ee1d947b970b95965b3172632a9ce90c29a9dfd24966e241b07'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754424340/amp-linux-x64'
      sha256 '9494783f13d035c5bf465d48ac32d40c5f4bf8dd7c73d27604e6af7a7b79efba'
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
