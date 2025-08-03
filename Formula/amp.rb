# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754222704/amp-darwin-arm64.zip'
  sha256 'f4bfa545a4b9494824cd2fc4d053dd8698c9a0345936e16320b1e417fc62afa8'
  version '0.0.1754222704'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754222704/amp-darwin-arm64.zip'
      sha256 'f4bfa545a4b9494824cd2fc4d053dd8698c9a0345936e16320b1e417fc62afa8'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754222704/amp-darwin-x64.zip'
      sha256 '45df73ecd054d58086cfa05ac6480a4b26b6f2554a1c76f965d576d4cf865453'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754222704/amp-linux-arm64'
      sha256 '7cce501d7de3d6054cb8dd599b5b0b26add8f6fe8652ecbc9377197b8f4644fa'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754222704/amp-linux-x64'
      sha256 'e4b6169ff00a98b0fb813e25144098f06329329b39afb1c9d938e803f068e0e1'
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
