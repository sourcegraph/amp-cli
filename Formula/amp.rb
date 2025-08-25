# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756094953/amp-darwin-arm64.zip'
  sha256 '56a50fa5598e4a21af49949bce22e39ed5393197254440f199c5fc0f188a2e5f'
  version '0.0.1756094953'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756094953/amp-darwin-arm64.zip'
      sha256 '56a50fa5598e4a21af49949bce22e39ed5393197254440f199c5fc0f188a2e5f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756094953/amp-darwin-x64.zip'
      sha256 '170bd165f5ba02f532c5a337337435e08969a191f9a734b5e91ff5a476e00407'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756094953/amp-linux-arm64'
      sha256 '7ef0dcca9dfa6ed2a039822acd63b530ed037b2c93b69ed7dd591defb4bebfc8'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756094953/amp-linux-x64'
      sha256 '93b1aa5e36ac58d6681fdb42248597c2c9a8df8784c72c018dcb1c9665e1423f'
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
