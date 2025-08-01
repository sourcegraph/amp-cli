# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://github.com/sourcegraph/amp-cli'
  url 'https://github.com/sourcegraph/amp-cli/archive/refs/tags/v0.0.1754035600.tar.gz'
  sha256 'a7ed425f4cdfcc5c51e2df29cc94de95245f84cdced297413b949177c1d6aec6'
  version '0.0.1754022453'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754022453/amp-darwin-arm64'
      sha256 '76168332b6cc793050bd71bf5357df6cc805819489ab617bbf1229cdeb198340'
    else
      url 'https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754022453/amp-darwin-x64'
      sha256 '7b700501c9dddb8a10dbad36a180576a6eb0fb63bdd94eabcc3537a2d3bd8151'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754022453/amp-linux-arm64'
      sha256 '213222afe829b05b0e1b6f16b5dd7ccafeb9a6ca2b32d43115f2eb4fb98ffd2b'
    else
      url 'https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754022453/amp-linux-x64'
      sha256 'aabef5e6484aed7d2226f23160a3e08e98a0a9fe178f47c10ac25decde966f4e'
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
