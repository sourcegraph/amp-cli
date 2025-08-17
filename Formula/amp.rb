# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755417945/amp-darwin-arm64.zip'
  sha256 '4cbc16b18b03399db302a4205ea33c95c15320428a982a300d285bb731f023c7'
  version '0.0.1755417945'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755417945/amp-darwin-arm64.zip'
      sha256 '4cbc16b18b03399db302a4205ea33c95c15320428a982a300d285bb731f023c7'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755417945/amp-darwin-x64.zip'
      sha256 'a5dfee0dcabfda50bdf0ee62d89f2e855fd39c2456c58d2728f03c7a6f5660ab'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755417945/amp-linux-arm64'
      sha256 '575206dd7529382b760f925e54b4cecb5318d9743e5a5f22249530cd48ea3e41'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755417945/amp-linux-x64'
      sha256 'e74180729248c438e9e9616ee6588fe4a344a42db215f439e8a93ec51296730d'
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
