# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756426707/amp-darwin-arm64.zip'
  sha256 'e220680bbe0c023610ccfe351b7414163818fd5f136abfcb130a7537f0444196'
  version '0.0.1756426707'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756426707/amp-darwin-arm64.zip'
      sha256 'e220680bbe0c023610ccfe351b7414163818fd5f136abfcb130a7537f0444196'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756426707/amp-darwin-x64.zip'
      sha256 'be8d89f8d643ac67306b77c0a53298dfb09a6f8874a1f641e4b27d947bb4d606'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756426707/amp-linux-arm64'
      sha256 '7e920478fe5efaa2958588376fb046cd336b56af31239f76b1a1b1ae119b1114'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756426707/amp-linux-x64'
      sha256 'ab6f8cbcc0fb94a7e31f1350e9c16158b2d6291a9c0914a0a959c9c0c2853f35'
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
