# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754309300/amp-darwin-arm64.zip'
  sha256 'e5961ccafca672f2757040e6edae08c3b9950829df491b8082901d7209b82d4b'
  version '0.0.1754309300'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754309300/amp-darwin-arm64.zip'
      sha256 'e5961ccafca672f2757040e6edae08c3b9950829df491b8082901d7209b82d4b'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754309300/amp-darwin-x64.zip'
      sha256 'f6cb9003682b78f52936073be3e4e3818a294f78b248bb008e8a797cd88f9f9d'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754309300/amp-linux-arm64'
      sha256 'e1c29815e1dd4af3efffb22b32f77f5786b7076b42a05642f098ce6aefe569b0'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754309300/amp-linux-x64'
      sha256 '4c17fdd0f9659b5bb1c83190dc132deb921a0aaa376bc0b38f6eb5b05bda6bd9'
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
