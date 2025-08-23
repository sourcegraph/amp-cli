# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755979480/amp-darwin-arm64.zip'
  sha256 'c1f6c6bd0cbbcb9395e8e5472163246224d6fef5ded8aac4d91ae7fe515a0862'
  version '0.0.1755979480'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755979480/amp-darwin-arm64.zip'
      sha256 'c1f6c6bd0cbbcb9395e8e5472163246224d6fef5ded8aac4d91ae7fe515a0862'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755979480/amp-darwin-x64.zip'
      sha256 'b752cf0a83a5b80513f207077641e6240520819ab9bd1417f0dfc7f550fc9d87'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755979480/amp-linux-arm64'
      sha256 'a6c8816cbe80449c85b393f71c0add3e6730ca8e11f06de6053a579a5bafa575'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755979480/amp-linux-x64'
      sha256 '7ed3d3f8c265c47f20eb9091a6cd9da7485ab7ad7d34cc030b0b647e1630af3c'
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
