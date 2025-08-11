# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754928355/amp-darwin-arm64.zip'
  sha256 '23d66d34f1e3f1536732f54255ac8fa63b60d4f77ac708fcfa4d82d8ce20aa52'
  version '0.0.1754928355'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754928355/amp-darwin-arm64.zip'
      sha256 '23d66d34f1e3f1536732f54255ac8fa63b60d4f77ac708fcfa4d82d8ce20aa52'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754928355/amp-darwin-x64.zip'
      sha256 '1fdf9627e058543e3b9643c19ebff12bfd25e76c07dca6c87701bd3487391418'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754928355/amp-linux-arm64'
      sha256 '19a9306350eb7165b9c021076a146b40c16f79e166de356a6d6722dfae8cdde5'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754928355/amp-linux-x64'
      sha256 'e39fc8eb0a59b97383d8e36f83b793ba2d716a6209dbb187f5d3f01d2a20145f'
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
