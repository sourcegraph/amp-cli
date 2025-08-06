# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754496405/amp-darwin-arm64.zip'
  sha256 'fb69a56d2c94ea9eeb25532f14919b3fe5d73d6e49ebcf6067d9556e77b0500d'
  version '0.0.1754496405'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754496405/amp-darwin-arm64.zip'
      sha256 'fb69a56d2c94ea9eeb25532f14919b3fe5d73d6e49ebcf6067d9556e77b0500d'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754496405/amp-darwin-x64.zip'
      sha256 'ff03ccb471a85eb50b619cf202f9e9fe23dc405a3ef77161b2c05f5340f54453'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754496405/amp-linux-arm64'
      sha256 'dfb86b25248df93fd48c921bc9dbb9e820ce378c6b5ac33bfc706f02648c09ec'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754496405/amp-linux-x64'
      sha256 'b068e125285069bab607ddcc81a1454c3074a64f1430c62a5df439c7e5bd3a28'
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
