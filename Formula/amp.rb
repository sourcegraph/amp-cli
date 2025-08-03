# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754226849/amp-darwin-arm64.zip'
  sha256 '17287c82f7feda6b5f8fdf1c6eb59dda7c95a1ae67ecc3107a1153a093a4b92b'
  version '0.0.1754226849'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754226849/amp-darwin-arm64.zip'
      sha256 '17287c82f7feda6b5f8fdf1c6eb59dda7c95a1ae67ecc3107a1153a093a4b92b'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754226849/amp-darwin-x64.zip'
      sha256 'f9abe701c6431162b681909da8b98363ef56d9b6cbed6c2e7bfe263d666b563e'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754226849/amp-linux-arm64'
      sha256 '251445ddfd53f97478c1bc0577ae6724c748acaa6cc7360a2f62a2380a8a4c02'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754226849/amp-linux-x64'
      sha256 'f97a7a6bca2ac3a90f592baf949c92258c1adec9688c9f553a5ba2291bc7e031'
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
