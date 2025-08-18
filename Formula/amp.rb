# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755533167/amp-darwin-arm64.zip'
  sha256 '79e8c5212e0ab7792577296624d7c4245c676839fecdc5e71035995fd0417d74'
  version '0.0.1755533167'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755533167/amp-darwin-arm64.zip'
      sha256 '79e8c5212e0ab7792577296624d7c4245c676839fecdc5e71035995fd0417d74'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755533167/amp-darwin-x64.zip'
      sha256 'b4b87f8c44bce69980e58d7834242200d27df761d0b35a9c18455430a461c935'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755533167/amp-linux-arm64'
      sha256 '4e08a38f7198cdc563265efe071f1fb6b68908ca421f4389be501153b96af1fb'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755533167/amp-linux-x64'
      sha256 'ac019639a9c259d7cc9e2e645a01eb7ca68fa0c7af1ce7e17552f9d8b25abc3f'
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
