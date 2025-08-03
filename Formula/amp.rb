# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754225131/amp-darwin-arm64.zip'
  sha256 '025d7c2b3192de769977d23b327f5e10b508b129a53af932d2fccd563c06c2ea'
  version '0.0.1754225131'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754225131/amp-darwin-arm64.zip'
      sha256 '025d7c2b3192de769977d23b327f5e10b508b129a53af932d2fccd563c06c2ea'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754225131/amp-darwin-x64.zip'
      sha256 '3eb5c066f963b0a801095d141160df502759fa71301b50a48afc2109bf6101b9'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754225131/amp-linux-arm64'
      sha256 '73de0aba84fa6a46b23b4751d9f77d5aba95ee8eb8f3b13077445955f8fd879e'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754225131/amp-linux-x64'
      sha256 'da79973e402a93cb87731db2795a02bd67a8ca05b147056a820d744ef53964fd'
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
