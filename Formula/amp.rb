# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755908267/amp-darwin-arm64.zip'
  sha256 'e4023dc6d75b2c845c5ac8f93610360f6c20f41bbd5377854c6129ee77c082fe'
  version '0.0.1755908267'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755908267/amp-darwin-arm64.zip'
      sha256 'e4023dc6d75b2c845c5ac8f93610360f6c20f41bbd5377854c6129ee77c082fe'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755908267/amp-darwin-x64.zip'
      sha256 '558a9e9cc9376b36d4b25a2f8bcc3f110b9d043435dd833f9a2fab3e15873a7e'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755908267/amp-linux-arm64'
      sha256 '95fe99ecbd502caa5d2cdc350de8cd2b024f75d667959a71fab32ada15ddd53b'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755908267/amp-linux-x64'
      sha256 'fd6dd061bd52239eb992e36568b386b3542ecfa6587bc323abd05599c89d8ab1'
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
