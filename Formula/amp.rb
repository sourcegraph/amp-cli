# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756513030/amp-darwin-arm64.zip'
  sha256 '02d82e65ae819073527c3d3a8b23ea3269b8cf3768c320ffc1c9d0a68ddebca1'
  version '0.0.1756513030'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756513030/amp-darwin-arm64.zip'
      sha256 '02d82e65ae819073527c3d3a8b23ea3269b8cf3768c320ffc1c9d0a68ddebca1'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756513030/amp-darwin-x64.zip'
      sha256 'af27282c7a8d3faa8582d4621aab5b2a3dd72d6f6bc866149e27ca66a923339b'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756513030/amp-linux-arm64'
      sha256 'c983a6da21a43c8a7e58882b1e2bb8a55c4e153d53abbff451d8c87f8371e1e3'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756513030/amp-linux-x64'
      sha256 '2f92ba58fedef6b96dbce299ce82d1f97731620e9d3d834f3e04139e32fdf9e3'
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
