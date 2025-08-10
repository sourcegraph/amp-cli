# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754841902/amp-darwin-arm64.zip'
  sha256 '18d98d5547f87f65134164b7d73ba4974776db214faf22a0de51127e18fccb5c'
  version '0.0.1754841902'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754841902/amp-darwin-arm64.zip'
      sha256 '18d98d5547f87f65134164b7d73ba4974776db214faf22a0de51127e18fccb5c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754841902/amp-darwin-x64.zip'
      sha256 '8acdf8489a8742d95ce96ab36f20ac7b7c3ce36658e8b86774320247b5a2cdb1'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754841902/amp-linux-arm64'
      sha256 '2035a73984394ccec205e1bf1c73d54a77f5aea20e576e02c750ef447fa45d5f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754841902/amp-linux-x64'
      sha256 '7369cc16304bbdeca40bf239926f3082ca92f66c2f35e591d0ce8c84749bfd2b'
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
