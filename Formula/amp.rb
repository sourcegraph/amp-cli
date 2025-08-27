# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756253887/amp-darwin-arm64.zip'
  sha256 '2b4719a9284fe0ef95005829b699b0460ec4e5ad2c6e8954315901f47f090564'
  version '0.0.1756253887'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756253887/amp-darwin-arm64.zip'
      sha256 '2b4719a9284fe0ef95005829b699b0460ec4e5ad2c6e8954315901f47f090564'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756253887/amp-darwin-x64.zip'
      sha256 '900f744a3057571047cd1c2f6d4408fcef71270fbab8e7980ad83f0f77dbcd02'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756253887/amp-linux-arm64'
      sha256 '7a71d2acf80327c337fd639150886a8f38f3d1a0016513a1a05dd591131681cd'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756253887/amp-linux-x64'
      sha256 'f17dc3bf119026d6714b5bdde5c2d8f383002a9770cbeafc823238ecb9dcdc7e'
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
