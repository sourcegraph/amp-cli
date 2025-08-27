# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756281968/amp-darwin-arm64.zip'
  sha256 '75e94796393d2b1a59e927c4cfcb9ab18409484812fa2b6d086d527a86bd7dd5'
  version '0.0.1756281968'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756281968/amp-darwin-arm64.zip'
      sha256 '75e94796393d2b1a59e927c4cfcb9ab18409484812fa2b6d086d527a86bd7dd5'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756281968/amp-darwin-x64.zip'
      sha256 '5ec7e5ef4e12362b1e62eae4f42c20c03be3cd6f4a7f86a7506f05b3e8ef12f1'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756281968/amp-linux-arm64'
      sha256 '9a6b14e2e2376a64f89bb6d00f0d2f1baa6b1526ca00304f79f598a18d7ec7ed'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756281968/amp-linux-x64'
      sha256 '6a547e008985749b6eb82ee26e8c6cfea23f51402ede3406d018bbfed414105d'
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
