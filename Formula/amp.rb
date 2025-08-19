# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755562791/amp-darwin-arm64.zip'
  sha256 '5af35fbcdc436db0ec7a87946542d8e419132235749ac8c195357d7a7ed81e02'
  version '0.0.1755562791'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755562791/amp-darwin-arm64.zip'
      sha256 '5af35fbcdc436db0ec7a87946542d8e419132235749ac8c195357d7a7ed81e02'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755562791/amp-darwin-x64.zip'
      sha256 '9cdad8c71b24d2585d7b89749a6ce0c028cbe30cf7291551ef43e754c7ff7173'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755562791/amp-linux-arm64'
      sha256 '571f505d75a7f1afbd74b352f37780f8ae8bcf3231fe1a6e53768d0baf094669'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755562791/amp-linux-x64'
      sha256 '31cf4257b5bb0406f3e01b8a007e6ccc2366ba9da6b7dd045a052e1adda3f136'
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
