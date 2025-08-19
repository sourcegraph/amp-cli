# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755633929/amp-darwin-arm64.zip'
  sha256 'c4b159d10dcb0dc45c1362759ebd634fb5e8de600767eb9d41ecc1bd4a9ad881'
  version '0.0.1755633929'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755633929/amp-darwin-arm64.zip'
      sha256 'c4b159d10dcb0dc45c1362759ebd634fb5e8de600767eb9d41ecc1bd4a9ad881'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755633929/amp-darwin-x64.zip'
      sha256 'bbb6f3b9d68647b7d022f96d53e61d8ae479aeb209108055a19697ec2273925d'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755633929/amp-linux-arm64'
      sha256 '3c8b6b76711d4cf9c3357b7e15c2dd300ee86cc50c0986ac84d0d9cb14b01963'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755633929/amp-linux-x64'
      sha256 'e519d7eea328b329173815f13123cc44ee62d6a221fcbfbd823c054957578b72'
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
