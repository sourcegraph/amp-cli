# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755303493/amp-darwin-arm64.zip'
  sha256 '77218ec1aa16a39e02366247c79fc67c1ff9d6c0dde02c458829f9538938985b'
  version '0.0.1755303493'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755303493/amp-darwin-arm64.zip'
      sha256 '77218ec1aa16a39e02366247c79fc67c1ff9d6c0dde02c458829f9538938985b'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755303493/amp-darwin-x64.zip'
      sha256 'ff4e47dce952420f483af07e5253ff3c7d6e3acf0af2d32a8658df617b547256'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755303493/amp-linux-arm64'
      sha256 'de734e75f38f6a0e4e468e39ebe686673df2f8b3db8454033974c5f1dbbc7315'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755303493/amp-linux-x64'
      sha256 'b90a156d42c51de07161748506005e59d9df6edbd13a63f07c15ab24bbb6326d'
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
