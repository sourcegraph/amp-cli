# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755850007/amp-darwin-arm64.zip'
  sha256 '3554b51a275238678e9db15936d55b98a1a1f98502e4ea50e663aa4488ca50c0'
  version '0.0.1755850007'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755850007/amp-darwin-arm64.zip'
      sha256 '3554b51a275238678e9db15936d55b98a1a1f98502e4ea50e663aa4488ca50c0'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755850007/amp-darwin-x64.zip'
      sha256 '560e7b0b57169fe2e860a8cdb71ef05c536715be1b0d22e23366ce43b932638d'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755850007/amp-linux-arm64'
      sha256 '5de3e73b522e34088a38b5ef7f4ba4d522b47ac93e84115247ad6a3f0723b2b2'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755850007/amp-linux-x64'
      sha256 '3718565e4487185d8b92cafb53daf76b8bb1478c6263315ee677fa878ea567b7'
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
