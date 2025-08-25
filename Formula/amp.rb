# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756109231/amp-darwin-arm64.zip'
  sha256 '4699da909e5af84d4ce739079d3dd559edea9a3e76b80b0d0d72b2ca4ab4e4b8'
  version '0.0.1756109231'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756109231/amp-darwin-arm64.zip'
      sha256 '4699da909e5af84d4ce739079d3dd559edea9a3e76b80b0d0d72b2ca4ab4e4b8'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756109231/amp-darwin-x64.zip'
      sha256 '2d481f2ee2944faa0dec0c52e934b0cfb8491854628885a37603e780ee879634'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756109231/amp-linux-arm64'
      sha256 'e56aba7a54453d9b587200353495461660af6d98fbec23cca19bca0a3a60e23c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756109231/amp-linux-x64'
      sha256 '2918602957ee0c9b35492f1469f42687d6bfd7508f2b1f8257abb8a77979a031'
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
