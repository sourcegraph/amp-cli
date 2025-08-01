# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://github.com/sourcegraph/amp-cli'
  url '                https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754015686/amp-darwin-arm64'
  sha256 'fa1c72ec69a0daf37c0b1e25dcbb2a0b0d54130d9ece1cde3606775ea8038f25'
  version '0.0.1754015686'

  on_macos do
    if Hardware::CPU.arm?
      url '                https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754015686/amp-darwin-arm64'
      sha256 'fa1c72ec69a0daf37c0b1e25dcbb2a0b0d54130d9ece1cde3606775ea8038f25'
    else
      url '                https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754015686/amp-darwin-x64'
      sha256 '1a6820c140916057853196fd102a0495f84c02da6851301cb11261242c41ae8e'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url '                https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754015686/amp-linux-arm64'
      sha256 'ec7753651b14628a7fed9e899ecf872ab90bf9f5f7b9de4163e9f7950f913236'
    else
      url '                https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754015686/amp-linux-x64'
      sha256 '5a6b8c0222e4bf43cd138cd1d6ddc8e53313afe5b35ede798dfcaa9fc7a15be2'
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
