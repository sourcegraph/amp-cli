# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754229919/amp-darwin-arm64.zip'
  sha256 'a839ccad1aefc071fc8df1a17d2b48e3739ab0cc2e2c999802e18761d1c826f5'
  version '0.0.1754229919'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754229919/amp-darwin-arm64.zip'
      sha256 'a839ccad1aefc071fc8df1a17d2b48e3739ab0cc2e2c999802e18761d1c826f5'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754229919/amp-darwin-x64.zip'
      sha256 '2aa8224ad4d494f06d8ad04ae19da378282e3f5b268cd56c7d47cef52d0ffae8'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754229919/amp-linux-arm64'
      sha256 '35363bed7e7e7ce5a8f35fc297634f500c51c331ed210864a5270ecea1a11f66'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754229919/amp-linux-x64'
      sha256 'a45d9e6d6847216efdaf7650ba3360db255908cf6729f03efd5b83895e53b610'
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
