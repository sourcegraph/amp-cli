# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754439620/amp-darwin-arm64.zip'
  sha256 '7bc7fc4c402100babbef39c5bc762894bf105b43f07693f54530494232af7b6b'
  version '0.0.1754439620'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754439620/amp-darwin-arm64.zip'
      sha256 '7bc7fc4c402100babbef39c5bc762894bf105b43f07693f54530494232af7b6b'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754439620/amp-darwin-x64.zip'
      sha256 '4cf51d531f9f74e6e9e9eb6dc5de7a6933625effc843e1cf7505f03f47fd0fec'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754439620/amp-linux-arm64'
      sha256 '8d4ac1e8c1bb569dfd914e87d2d5559e5869479fe416b9e96e7dbf21d861d904'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754439620/amp-linux-x64'
      sha256 'c76623712d891d79ea59f482f542ba31a1d23a17aaf7d3ddc9b2c8891dbaa45c'
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
