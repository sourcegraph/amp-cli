# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755245184/amp-darwin-arm64.zip'
  sha256 '85105f892af87c510567a4ce031e7b5b03f670ef3b56a602cd78d47c37123ab3'
  version '0.0.1755245184'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755245184/amp-darwin-arm64.zip'
      sha256 '85105f892af87c510567a4ce031e7b5b03f670ef3b56a602cd78d47c37123ab3'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755245184/amp-darwin-x64.zip'
      sha256 '21a072a76360ba77bf91150cf53b8c63a04c6dc0fd9ea9b7cfab77f738283942'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755245184/amp-linux-arm64'
      sha256 '4709b0d7ca160b5e7cb3729385d17aa06892aabc2d9f6f6582a4acd1ff426039'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755245184/amp-linux-x64'
      sha256 'b187722ca84da20f5b77976d1780323f74aad07840f7b3dc0ba154046a1f637f'
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
