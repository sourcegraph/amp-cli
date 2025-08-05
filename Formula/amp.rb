# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754409962/amp-darwin-arm64.zip'
  sha256 'f36b227ca281f64a51d781426d3e86b4ae59152fd4c2db1754383164349df14f'
  version '0.0.1754409962'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754409962/amp-darwin-arm64.zip'
      sha256 'f36b227ca281f64a51d781426d3e86b4ae59152fd4c2db1754383164349df14f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754409962/amp-darwin-x64.zip'
      sha256 '24072c932860f9ee252be7a47f3b3faef2e7ee8d09babf1c8d5ecaea22201de2'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754409962/amp-linux-arm64'
      sha256 'c066cde1a6e758d8b3b39a662f0e07941f46558b567623220adb6a4c33cb4c2f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754409962/amp-linux-x64'
      sha256 'ef2036b7c6d902552ae73f4d582b37299d785320a99b1d24f795ba69f1aad5f2'
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
