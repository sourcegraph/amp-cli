# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756440329/amp-darwin-arm64.zip'
  sha256 '3618a3930548e03642c3775ee8eaf90716ea5b90b533b445e24294b9d899e4d4'
  version '0.0.1756440329'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756440329/amp-darwin-arm64.zip'
      sha256 '3618a3930548e03642c3775ee8eaf90716ea5b90b533b445e24294b9d899e4d4'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756440329/amp-darwin-x64.zip'
      sha256 '6d94e8f46ebe07c35cd81f1fd2d15c2737162dde4b2ed24826d3875bf8a600e2'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756440329/amp-linux-arm64'
      sha256 'ea6e7ed8ea3a8a1190dcb38d9018ee240629a34f1d730aaa11312445516c3485'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756440329/amp-linux-x64'
      sha256 'f472735fbf68996a808263f64e7e820f9af821a2b5c59340b46a4e614a27d1a5'
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
