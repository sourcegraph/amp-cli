# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755461101/amp-darwin-arm64.zip'
  sha256 '3ecc8b6da81886a1d641368444d086b0ccc3594de2b10dce9b068253b92a3f09'
  version '0.0.1755461101'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755461101/amp-darwin-arm64.zip'
      sha256 '3ecc8b6da81886a1d641368444d086b0ccc3594de2b10dce9b068253b92a3f09'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755461101/amp-darwin-x64.zip'
      sha256 'e39ad92fe1f0874c1fb32b42f8fad0356186333398eb8834864f7f326a1895bc'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755461101/amp-linux-arm64'
      sha256 'd1f77e776cc0706e3594de55abe58c0b2165c4a748cfaea8ef805a8174d7a64a'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755461101/amp-linux-x64'
      sha256 'be878cc78f16566f53fd700a3447cdd806ea97743d0c206df0cc134b4d6235e1'
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
