# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754501720/amp-darwin-arm64.zip'
  sha256 '6660e4b622100b21b7eca2a94835f8155a479f0fa68d50eb99435380dfd55fdc'
  version '0.0.1754501720'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754501720/amp-darwin-arm64.zip'
      sha256 '6660e4b622100b21b7eca2a94835f8155a479f0fa68d50eb99435380dfd55fdc'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754501720/amp-darwin-x64.zip'
      sha256 '13e55767fc42fbf261de865186cb84970de34d235fb71684de4ebe255c8a8ede'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754501720/amp-linux-arm64'
      sha256 'a258a62c667aca9756cee399b2781ceb83d214eb0197ed1944f317ed21f1d0e7'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754501720/amp-linux-x64'
      sha256 '4054832ddd502959efc53d46bdcc3b8062960886591658e5862923fe1cca0c58'
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
