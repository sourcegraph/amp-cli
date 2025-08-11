# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754942731/amp-darwin-arm64.zip'
  sha256 '5c93995ab206aaf15fe2c5a2feeb5abc2a24a0ca328e127f264f691a3c4c5285'
  version '0.0.1754942731'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754942731/amp-darwin-arm64.zip'
      sha256 '5c93995ab206aaf15fe2c5a2feeb5abc2a24a0ca328e127f264f691a3c4c5285'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754942731/amp-darwin-x64.zip'
      sha256 'e6d2f104c36cedbaf494bf302f6836db1342e150b14a508202639e110d350cbd'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754942731/amp-linux-arm64'
      sha256 '0cd5066e738244a366d7401c46f9514b45535fa1ce29898529ea749cbe0f5336'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754942731/amp-linux-x64'
      sha256 '0d51f0e8f4b8963806dd084f344c8d17dd56cfb753d32da0e03250b20e164de8'
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
