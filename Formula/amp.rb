# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754482116/amp-darwin-arm64.zip'
  sha256 '6c0619c174a54b6578904ab09c44d6a33958727e3b4d16d06eaedbe526a060a8'
  version '0.0.1754482116'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754482116/amp-darwin-arm64.zip'
      sha256 '6c0619c174a54b6578904ab09c44d6a33958727e3b4d16d06eaedbe526a060a8'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754482116/amp-darwin-x64.zip'
      sha256 '189489b27804438c92c84675f31982ba7442e758d42c5501131bcd23992a8d77'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754482116/amp-linux-arm64'
      sha256 '5d9017a5849d9223dfa272b8c22c8824d8aa34e973ab0fb2f38dddf6e294e317'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754482116/amp-linux-x64'
      sha256 '905020cf855c19c0cd6a636544e26f3d389da835ccfd967bc7e07f6ebb52e4a5'
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
