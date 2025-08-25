# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756081151/amp-darwin-arm64.zip'
  sha256 '34fd96a58eb1da231bfb63d58ccc70d100f1ad435dab693f45d67002a3117dfc'
  version '0.0.1756081151'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756081151/amp-darwin-arm64.zip'
      sha256 '34fd96a58eb1da231bfb63d58ccc70d100f1ad435dab693f45d67002a3117dfc'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756081151/amp-darwin-x64.zip'
      sha256 '7ae40e298319f5f6a01483ebfc51a0a3d6bc35527f728c6d540071a37645b69f'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756081151/amp-linux-arm64'
      sha256 '5cebf1423bd15a869e4c1e10041d2870978bc191b9d2dd77f547aac4db6e8494'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756081151/amp-linux-x64'
      sha256 'faeffdb734f327947e1695453133bcf4bbf9f87908d654d52b8da35453dfe4aa'
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
