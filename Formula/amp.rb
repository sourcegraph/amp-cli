# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754226230/amp-darwin-arm64.zip'
  sha256 'd7745dc7ff7506a1dc16d9d758ceefdcb066f1a5611911a82de79b1a8ef2e187'
  version '0.0.1754226230'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754226230/amp-darwin-arm64.zip'
      sha256 'd7745dc7ff7506a1dc16d9d758ceefdcb066f1a5611911a82de79b1a8ef2e187'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754226230/amp-darwin-x64.zip'
      sha256 'ed690fa7a73c4e4f29cf366f93d66b5be0b6832030fb3a329e71273772f9727c'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754226230/amp-linux-arm64'
      sha256 'fbfef09786bba3a65a22c5cc1d149dfd05c8ff25e1cf874e2cd557f23a72c6d4'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754226230/amp-linux-x64'
      sha256 '4ff2346bd070c40375445536aac0d511328a7a0f06b179af2f20903d96e0fce9'
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
