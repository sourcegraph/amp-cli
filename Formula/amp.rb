# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754201547/amp-darwin-arm64.zip'
  sha256 '365a52738e50d117752b80bfbb00ddf65b68a0f301262bababf41afb566c42bd'
  version '0.0.1754201547'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754201547/amp-darwin-arm64.zip'
      sha256 '365a52738e50d117752b80bfbb00ddf65b68a0f301262bababf41afb566c42bd'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754201547/amp-darwin-x64.zip'
      sha256 '3168fe3445ebea28e98680f02e97b6a2567392fcab69949ddcd9bf7730293917'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754201547/amp-linux-arm64'
      sha256 '5533f1f793f8cacec6d27c3f0d0162c780fdb0e53134a567ba56aa267ea6cd7c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754201547/amp-linux-x64'
      sha256 '148df6a645693d7571fa6ac4b9293368bd65fdab0cf96d8ae837dfabe17f43f6'
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
