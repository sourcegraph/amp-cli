# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754367769/amp-darwin-arm64.zip'
  sha256 'f239105afdce1cfca0f8ff2a8685936c2450b05f374516fc93042206c885efd5'
  version '0.0.1754367769'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754367769/amp-darwin-arm64.zip'
      sha256 'f239105afdce1cfca0f8ff2a8685936c2450b05f374516fc93042206c885efd5'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754367769/amp-darwin-x64.zip'
      sha256 '1e50429efd20fb3f36831de9ccb777beb59283a09e1c42120a002721938e3ee1'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754367769/amp-linux-arm64'
      sha256 '1718350c6786eb7678ab1e0b5a820c415a9913dccf9ca44f52ffd5bdeab850f2'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754367769/amp-linux-x64'
      sha256 '0f044dffda5418a39db82c9a966bb24f0989cb280368d79a65ea85dd11cd2605'
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
