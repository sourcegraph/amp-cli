# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756569884/amp-darwin-arm64.zip'
  sha256 '05661675bc025784d7bce610c1c6e7f80f012c6a1f877d364558e5c0abfe97bf'
  version '0.0.1756569884'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756569884/amp-darwin-arm64.zip'
      sha256 '05661675bc025784d7bce610c1c6e7f80f012c6a1f877d364558e5c0abfe97bf'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756569884/amp-darwin-x64.zip'
      sha256 '278ab0a2c5778c204d020fc0782296fe310080a9e327d923a3b51000828cc46e'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756569884/amp-linux-arm64'
      sha256 '6a1416f7d16619e7f94c44727296d33a1b65dc397134b5233c10e15801e30b9c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756569884/amp-linux-x64'
      sha256 'fef08eddcbed36c00c900da3cbc6d8e24f9c96c100eb9d75904807a511cf5137'
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
