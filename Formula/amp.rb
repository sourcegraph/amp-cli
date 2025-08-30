# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756526730/amp-darwin-arm64.zip'
  sha256 'dba5c5f72de615b7b26c9d3c2e41e76bf8e980870a0ec541f3b391985431663e'
  version '0.0.1756526730'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756526730/amp-darwin-arm64.zip'
      sha256 'dba5c5f72de615b7b26c9d3c2e41e76bf8e980870a0ec541f3b391985431663e'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756526730/amp-darwin-x64.zip'
      sha256 'e6ada478041264ec74a90b8285af5e5488559d0ef931fcd84b890b2e6330ad24'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756526730/amp-linux-arm64'
      sha256 '0bf5f2d987a25f1d195225838b0da8fac8c28b4cf09921e717bc2d9748c29291'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756526730/amp-linux-x64'
      sha256 'b34a26c92227e3cc3dd55555b81610397264f20d834c38ed510bf68415f7f81a'
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
