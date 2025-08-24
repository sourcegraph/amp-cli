# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756037214/amp-darwin-arm64.zip'
  sha256 'da36d83686ae847eb44bd911f7dbea17784b470b753954e7cfbfde402ad3c0ff'
  version '0.0.1756037214'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756037214/amp-darwin-arm64.zip'
      sha256 'da36d83686ae847eb44bd911f7dbea17784b470b753954e7cfbfde402ad3c0ff'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756037214/amp-darwin-x64.zip'
      sha256 'd31c51cb2dd651ac4b28034b5a0b6699915c157401421c15951fbd9ad62d345d'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756037214/amp-linux-arm64'
      sha256 '6af8599f695f6cd3dc931df62b51ffd3a93e3699f254f30489892fb92c7c80b6'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756037214/amp-linux-x64'
      sha256 '0ef540fb4f87ee226a1fedf44e5042cd9c104b876b2f9631031ab554d69df335'
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
