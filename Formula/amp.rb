# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755504411/amp-darwin-arm64.zip'
  sha256 'cc2550c2ce9e4ec4405a7b148464f458a6940efca6c37b883f3a9a4d664eae41'
  version '0.0.1755504411'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755504411/amp-darwin-arm64.zip'
      sha256 'cc2550c2ce9e4ec4405a7b148464f458a6940efca6c37b883f3a9a4d664eae41'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755504411/amp-darwin-x64.zip'
      sha256 '9f168f7609ccfea61d30158495f3cb6f04faf18aadb24a30391ccb71aa37404b'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755504411/amp-linux-arm64'
      sha256 'a1880eb510b1795cbeec0ddba3760c1a63ea0d55d3032b391ce06698100c4589'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755504411/amp-linux-x64'
      sha256 '18cb4cc3e4c6e71798881df3014c4d023e8fc8c47bcbd14a00be60fe780c92df'
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
