# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755058312/amp-darwin-arm64.zip'
  sha256 '5a9101e5e6722239e0169d01239bb29b825e1d5c8c0d1261342b7b2425917a7f'
  version '0.0.1755058312'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755058312/amp-darwin-arm64.zip'
      sha256 '5a9101e5e6722239e0169d01239bb29b825e1d5c8c0d1261342b7b2425917a7f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755058312/amp-darwin-x64.zip'
      sha256 '9a30df78603e7cace9ab9f186aabf1c2ce7c52cd61c6a1a1826601c5bab30ec2'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755058312/amp-linux-arm64'
      sha256 'ad468df2258e1fbbfbdc8e890e758375c90f506152f20a0d6c2a9061080538d8'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755058312/amp-linux-x64'
      sha256 'f07c6c3db6bd764a93871b21275400b89087ce2e0c82cfd5f00fd569210f85da'
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
