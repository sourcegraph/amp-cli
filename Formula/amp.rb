# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754582753/amp-darwin-arm64.zip'
  sha256 '458453a304fcd28357197f10a387cd99f4bf71c7926c10de491811229cccbed2'
  version '0.0.1754582753'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754582753/amp-darwin-arm64.zip'
      sha256 '458453a304fcd28357197f10a387cd99f4bf71c7926c10de491811229cccbed2'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754582753/amp-darwin-x64.zip'
      sha256 '1398575ba7e1834010a33e4f7f4a759618e8c1bfc943f1c0e8c8829dc89cac8c'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754582753/amp-linux-arm64'
      sha256 '7c1bde9729a873a28ffd43a72674486de67a9023905f0e2271405047ddb4155f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754582753/amp-linux-x64'
      sha256 '3bb193ace65e5bc427a194191d98a02c68d8853460c25063a3499804ff8042e2'
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
