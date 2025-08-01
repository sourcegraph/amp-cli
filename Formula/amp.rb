# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://github.com/sourcegraph/amp-cli'
  url '                https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754015686/amp-darwin-arm64'
  sha256 ''
  version '0.0.1754015686'

  on_macos do
    if Hardware::CPU.arm?
      url '                https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754015686/amp-darwin-arm64'
      sha256 ''
    else
      url '                https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754015686/amp-darwin-x64'
      sha256 ''
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
