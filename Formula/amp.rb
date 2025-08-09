# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754741242/amp-darwin-arm64.zip'
  sha256 'e01be4ff01d6c82436702f47cd4d408d521f361029e1d3e85dc7cb2243d85d0f'
  version '0.0.1754741242'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754741242/amp-darwin-arm64.zip'
      sha256 'e01be4ff01d6c82436702f47cd4d408d521f361029e1d3e85dc7cb2243d85d0f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754741242/amp-darwin-x64.zip'
      sha256 'de154544858eccb19a37851b1c0d8965c840c06308200ee4d8d029268a8d5eaf'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754741242/amp-linux-arm64'
      sha256 'c7e619078bd70b26782177a0a9514f6adf93882b01a774f85d9d9e038bcf1619'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754741242/amp-linux-x64'
      sha256 '4bcc364451c53c43bf6beddcf503038d3c0ebb6c4a8d216d33ed332a1eeef2df'
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
