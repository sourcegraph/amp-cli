# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755878743/amp-darwin-arm64.zip'
  sha256 '6d8f6dd1e85b925a41ede3e03189ae9305b783d5053655228ed337e557acb3af'
  version '0.0.1755878743'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755878743/amp-darwin-arm64.zip'
      sha256 '6d8f6dd1e85b925a41ede3e03189ae9305b783d5053655228ed337e557acb3af'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755878743/amp-darwin-x64.zip'
      sha256 '164dcaad81713bffd264e2b1a8af672f94eff7f456204516e397503c49fac326'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755878743/amp-linux-arm64'
      sha256 '541dc1e753a81fc5049f0c171608839f39f87ea3eb8c3ac491dd0ac331bbf3c9'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755878743/amp-linux-x64'
      sha256 'bf605623e816ef9e2dc6cd9657f3820996712e4443e810f83e52be8754704115'
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
