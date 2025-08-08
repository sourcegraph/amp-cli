# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754612420/amp-darwin-arm64.zip'
  sha256 '8b6b515ba3eab19de4a8b9b2404c4c5efe608c66aa209f619dda733f993abb71'
  version '0.0.1754612420'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754612420/amp-darwin-arm64.zip'
      sha256 '8b6b515ba3eab19de4a8b9b2404c4c5efe608c66aa209f619dda733f993abb71'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754612420/amp-darwin-x64.zip'
      sha256 '086b148fdcd083bc158d34e04799182fa3b707235b3668964b4bdd652a78a6cf'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754612420/amp-linux-arm64'
      sha256 '479066355e116b4abb900415c9128ee5e48e663692420e44bbc1fead1f6ba093'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754612420/amp-linux-x64'
      sha256 'c7f3ee1844add27ba5ed98c3be7e4254cf5deec310f163259045285c93753480'
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
