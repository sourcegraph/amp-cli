# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755518894/amp-darwin-arm64.zip'
  sha256 'a91c6bafd7d9ecd66d9990c77a70533cca8b69f29b2ff4721037049269f73b51'
  version '0.0.1755518894'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755518894/amp-darwin-arm64.zip'
      sha256 'a91c6bafd7d9ecd66d9990c77a70533cca8b69f29b2ff4721037049269f73b51'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755518894/amp-darwin-x64.zip'
      sha256 'f543abf301065558385b809d2a6a26caa453cd96f5fd9434bccba4a0e8c9e63a'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755518894/amp-linux-arm64'
      sha256 '905ccb8928de8d993a5013d5bbf6df449c8f7745a1862896b409824b8919e1d4'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755518894/amp-linux-x64'
      sha256 '710e070350f5d2a4c1b1afb1c3866dec8a151764cd1f024095aa3c9159580985'
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
