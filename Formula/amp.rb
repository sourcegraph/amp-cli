# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755649088/amp-darwin-arm64.zip'
  sha256 'd3f9a9298a8bd1d145c02ca695d97458fef59579d4ce0853292cae1c314fd8bc'
  version '0.0.1755649088'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755649088/amp-darwin-arm64.zip'
      sha256 'd3f9a9298a8bd1d145c02ca695d97458fef59579d4ce0853292cae1c314fd8bc'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755649088/amp-darwin-x64.zip'
      sha256 'a20aa1616b63e13a3e4e690e8fce7f691d1809acab958684d5c72c79a87a7f37'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755649088/amp-linux-arm64'
      sha256 '8dcb584c7b508832d3d617bcbb51b014ff7c4ad043d59fa388ad3714bfc1fdd0'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755649088/amp-linux-x64'
      sha256 'f4fe7028696f80fe8b51bc6f5c0d3b81fd1f28eae087ab602e0207835f15bc81'
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
