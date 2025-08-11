# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754871668/amp-darwin-arm64.zip'
  sha256 '2977356b97a15c8b0c9e0d26c7b79112ae371916d284941cac30b2b4b5811943'
  version '0.0.1754871668'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754871668/amp-darwin-arm64.zip'
      sha256 '2977356b97a15c8b0c9e0d26c7b79112ae371916d284941cac30b2b4b5811943'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754871668/amp-darwin-x64.zip'
      sha256 '8aec55dab64eb5b2ebe2094eaa2d92148e844a5d3705f5883902d562bb255481'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754871668/amp-linux-arm64'
      sha256 '20fa61fa20621b2b1eebcfd4853bf049565cc21c52b2a43ed10cd10e352f011e'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754871668/amp-linux-x64'
      sha256 'd14155229d58b68fe355760a18128215ffff49d9335791953ca04a7a93bd1b2a'
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
