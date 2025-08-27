# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756325111/amp-darwin-arm64.zip'
  sha256 '8cdd3041a0fbffb76395ce1a88c91fe22f19220e694b97481e1cee07d92106a6'
  version '0.0.1756325111'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756325111/amp-darwin-arm64.zip'
      sha256 '8cdd3041a0fbffb76395ce1a88c91fe22f19220e694b97481e1cee07d92106a6'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756325111/amp-darwin-x64.zip'
      sha256 'a50484def274435a460a90825bbe957fd1343050f03223609b5d404bcaac174a'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756325111/amp-linux-arm64'
      sha256 '296feab44ac7bcdd6cfeba1aa15152852ad5fac676e01b34805aeaa652415d57'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756325111/amp-linux-x64'
      sha256 'da198fe659821f6b404de4c59cae1e064463aaac7c2920e3ed46f70e8f6dec8f'
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
