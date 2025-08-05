# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754358061/amp-darwin-arm64.zip'
  sha256 '6f961fc4eca7f3c89dd8dbd36d1d5a127aab976294d110e2db64279e74787f0b'
  version '0.0.1754358061'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754358061/amp-darwin-arm64.zip'
      sha256 '6f961fc4eca7f3c89dd8dbd36d1d5a127aab976294d110e2db64279e74787f0b'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754358061/amp-darwin-x64.zip'
      sha256 '796c55d875e45d72e9ada2d470bcc9c8db3de0fe9b679fd3a08e79d6ca691cd6'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754358061/amp-linux-arm64'
      sha256 'eeb85299ec74b763e9b0f0da2b232b5043341b84b3f6282a8cb6d63de4f705d8'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754358061/amp-linux-x64'
      sha256 '38cb755a99b471c55777f9b1a3f9c5ae0c9510fd924772d917d3a99d94225e7e'
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
