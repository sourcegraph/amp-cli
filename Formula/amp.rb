# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755501241/amp-darwin-arm64.zip'
  sha256 'f8529c6ca73cedd9926eeb0c886a822530c70dc38712908b5216d47a78450de6'
  version '0.0.1755501241'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755501241/amp-darwin-arm64.zip'
      sha256 'f8529c6ca73cedd9926eeb0c886a822530c70dc38712908b5216d47a78450de6'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755501241/amp-darwin-x64.zip'
      sha256 'db06f52750822508dfabc13e0569b03480db6c5b25eb2c8cfaae8c5bb083e007'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755501241/amp-linux-arm64'
      sha256 '88746a499caa4ae4306eeb6b35dfcabb0116f835fdef64f4cba8f28b1b8a092a'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755501241/amp-linux-x64'
      sha256 'fea4305a0d119839a0a4e3e3add0e4cc9c24168cbb8206dd51d566545f0239f5'
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
