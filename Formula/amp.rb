# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755072394/amp-darwin-arm64.zip'
  sha256 '57a8602ca2b34eab460ac2f307665eebd81d2585a045f1956eaf091dc47da0d8'
  version '0.0.1755072394'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755072394/amp-darwin-arm64.zip'
      sha256 '57a8602ca2b34eab460ac2f307665eebd81d2585a045f1956eaf091dc47da0d8'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755072394/amp-darwin-x64.zip'
      sha256 '2e463cc0817563a8e0b086608ad6428f506e7754ebeba3ba671f7e8adb06d0c7'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755072394/amp-linux-arm64'
      sha256 'ed8d55dacfc43ed69a242a35f2f37a7018df8f56fb5f084714bf630b0a2b6887'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755072394/amp-linux-x64'
      sha256 '3628eddf06d8681f5fc4343ba8fbb8d450bcea45a3a7ac818c168405fa03f7f1'
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
