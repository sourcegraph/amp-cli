# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756454776/amp-darwin-arm64.zip'
  sha256 '58ca8973eca03fe70c0c8294bde3ae27bdb113f57d2a73a3e3d1d360a9078d75'
  version '0.0.1756454776'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756454776/amp-darwin-arm64.zip'
      sha256 '58ca8973eca03fe70c0c8294bde3ae27bdb113f57d2a73a3e3d1d360a9078d75'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756454776/amp-darwin-x64.zip'
      sha256 'e26ded634f56e4533f21c7fb239201be12d34da647dc5d014d5063cd0c3f1ce7'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756454776/amp-linux-arm64'
      sha256 '92338363f723b5054c4bea5ffd9f24f167172145c7473dddecd43785215e591c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756454776/amp-linux-x64'
      sha256 '5d9c8c878b34543d0f0703c5c8381144be856233ae403ddd3ae92850a8b81cce'
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
