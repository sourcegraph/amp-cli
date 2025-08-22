# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755893117/amp-darwin-arm64.zip'
  sha256 'ddaa1f915a7cce64d9bfb891a070f702fd5c42033fda4ab730553a6877568e9b'
  version '0.0.1755893117'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755893117/amp-darwin-arm64.zip'
      sha256 'ddaa1f915a7cce64d9bfb891a070f702fd5c42033fda4ab730553a6877568e9b'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755893117/amp-darwin-x64.zip'
      sha256 '118e0a062eaef3adf10806a8ed05eb8dd83f1d0a81289fdb71f7f60d1a3e9b83'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755893117/amp-linux-arm64'
      sha256 'cace184f81b9abf2093b5112cefe8ec495ad4b33dca28fac70a6b08cbc54aebe'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755893117/amp-linux-x64'
      sha256 'ab8adce7fa2e62076f876c9f98a81fc78884c98d1bcff569a2fcc794d8138bf6'
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
