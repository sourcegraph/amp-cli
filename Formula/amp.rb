# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756353936/amp-darwin-arm64.zip'
  sha256 '649b7acbf120c3e481b4506fe9ceb459fbbebd9203b64f698891af17d7dae226'
  version '0.0.1756353936'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756353936/amp-darwin-arm64.zip'
      sha256 '649b7acbf120c3e481b4506fe9ceb459fbbebd9203b64f698891af17d7dae226'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756353936/amp-darwin-x64.zip'
      sha256 '34d06854f7ce30c6cca916364fd3fcfa71ba2d79cc8a16fdd1bdfee26adc718f'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756353936/amp-linux-arm64'
      sha256 '1f9add03216c3dcb8d62a0228c17ce296fb321c39c4282c846bdbf3bf8eec6cb'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756353936/amp-linux-x64'
      sha256 '6eb18e6554fb9b96f6ab760aea110b09225fb6db6e4b594095efbd7daa264423'
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
