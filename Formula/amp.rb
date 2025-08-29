# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756497920/amp-darwin-arm64.zip'
  sha256 'bd9c6dd313b8c70933a54350cb3a62422c7773f527fa21a15e81fcb73bbaa36c'
  version '0.0.1756497920'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756497920/amp-darwin-arm64.zip'
      sha256 'bd9c6dd313b8c70933a54350cb3a62422c7773f527fa21a15e81fcb73bbaa36c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756497920/amp-darwin-x64.zip'
      sha256 '48722b958c9b5c5c8c07cbcab2f476e296e631a3b56cb55f0f777b30f851c063'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756497920/amp-linux-arm64'
      sha256 '589777375b141e7c9718bef3a1444db37e5d40cc0ebd600cd75ad4a25ba6c6dd'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756497920/amp-linux-x64'
      sha256 '022ad0300585157526c9bcf8e7a1c39b6a775991bd1457ca394810cd6217919d'
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
