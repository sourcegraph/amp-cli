# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755404022/amp-darwin-arm64.zip'
  sha256 '122064be4fe369ee36d9065bfff2a665dcd5d9fd007a568d8c97d15db402c0a5'
  version '0.0.1755404022'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755404022/amp-darwin-arm64.zip'
      sha256 '122064be4fe369ee36d9065bfff2a665dcd5d9fd007a568d8c97d15db402c0a5'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755404022/amp-darwin-x64.zip'
      sha256 '429a64078c10f579a0761457b18c040f19d00e717c05e34b5f6d10dc65f0d840'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755404022/amp-linux-arm64'
      sha256 '4af692f495465515391bec23985d8d551ae671ba18eaf49b9cee6a9dbf9b2f11'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755404022/amp-linux-x64'
      sha256 '53223e55c1bca5e7697d204890d85f35db5e1f99221958a68311b40a04c2d062'
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
