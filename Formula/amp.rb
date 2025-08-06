# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754462457/amp-darwin-arm64.zip'
  sha256 '39082fab3e6580164c5b03e9e0397763119f6c6163efceb371b629c3372d9eeb'
  version '0.0.1754462457'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754462457/amp-darwin-arm64.zip'
      sha256 '39082fab3e6580164c5b03e9e0397763119f6c6163efceb371b629c3372d9eeb'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754462457/amp-darwin-x64.zip'
      sha256 '678b95353b292644b170c58754a2e5efad17154273cdb169ba4e5f8277bbb3dd'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754462457/amp-linux-arm64'
      sha256 'b0985c4ff594fc4d570e54fdeddae733da38b7f6e9ade0ae9541d088fdcfa7cf'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754462457/amp-linux-x64'
      sha256 'c2b5f7b2343f914e3726fbfda04b9881c36073c6ef8b85619c033b2f68968112'
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
