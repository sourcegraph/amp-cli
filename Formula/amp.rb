# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756310739/amp-darwin-arm64.zip'
  sha256 '1d5e7b16fb8df31885000054a5aa969cef67cba4ad4d04179b86d81e31b2c2cd'
  version '0.0.1756310739'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756310739/amp-darwin-arm64.zip'
      sha256 '1d5e7b16fb8df31885000054a5aa969cef67cba4ad4d04179b86d81e31b2c2cd'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756310739/amp-darwin-x64.zip'
      sha256 '8fc02e32b7a970ac10774e8c767fb1d60624cfbbc28b7b5af709aa951a3e2cb3'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756310739/amp-linux-arm64'
      sha256 '245a3a99e20a13304acfe0dda4337d59acae3fda67b7eb8bc9e43abb2226799c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756310739/amp-linux-x64'
      sha256 '2ea958ee8aa7f07f94e82212f4d3ad33955c080f9d8bfd7e9b7b4578e29832bc'
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
