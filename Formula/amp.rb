# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754467595/amp-darwin-arm64.zip'
  sha256 '2f3409a1861cdc9a2205c6f2638f54c18689f6a2a60546f9c88e5abe99622308'
  version '0.0.1754467595'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754467595/amp-darwin-arm64.zip'
      sha256 '2f3409a1861cdc9a2205c6f2638f54c18689f6a2a60546f9c88e5abe99622308'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754467595/amp-darwin-x64.zip'
      sha256 'f491f36ba14798e66db6ef6a4e0cbf8beb7a86d4aac6123444227a6b4434be6a'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754467595/amp-linux-arm64'
      sha256 '9664d933ea91f47736aa86847127036abcd679fd305c06cbba6dce3885e8b962'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754467595/amp-linux-x64'
      sha256 '953996cc0ca0cb2d95b644dfe8ddc2d05e5bad24bf1ee53b90a01c171e126d2d'
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
