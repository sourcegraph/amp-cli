# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754568559/amp-darwin-arm64.zip'
  sha256 '714e8a572702cf07a09ffe4e2f0c196fc763327083bbb1305dbf77deea9fe052'
  version '0.0.1754568559'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754568559/amp-darwin-arm64.zip'
      sha256 '714e8a572702cf07a09ffe4e2f0c196fc763327083bbb1305dbf77deea9fe052'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754568559/amp-darwin-x64.zip'
      sha256 'bec5b6e8c2bcd8b482bbbb23a87cf4c3af81f847b6b8e24a7c18a400ce31d024'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754568559/amp-linux-arm64'
      sha256 '73651f3f9588750f01ca2464e160d92de74ff2beab04b311a360dbdc916980b7'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754568559/amp-linux-x64'
      sha256 '698e7f9759156f04dfc29afe870aa5aa605302ba68368c64224aedc3b5defae6'
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
