# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754216895/amp-darwin-arm64.zip'
  sha256 'c153b5fac8be47bdbad7da1eb1b48218784d7bc3c0c31f47fd366f318e36f96b'
  version '0.0.1754216895'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754216895/amp-darwin-arm64.zip'
      sha256 'c153b5fac8be47bdbad7da1eb1b48218784d7bc3c0c31f47fd366f318e36f96b'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754216895/amp-darwin-x64.zip'
      sha256 '2b04754b53464138b1f33f9d505c2d3c7d6b007b613e663d7ec38203d37e7ab8'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754216895/amp-linux-arm64'
      sha256 'a158dc1579149aeb4d814b8fd699a6ac18390c2baf2b5e89d71ecfc53a121287'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754216895/amp-linux-x64'
      sha256 '7963f8bf5f9c433b436171ac40285ac65f62fd736ee083faacaa8a5a3c474a4c'
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
