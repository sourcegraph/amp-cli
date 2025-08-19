# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755576355/amp-darwin-arm64.zip'
  sha256 '43d414867295d04be30ed272cab1fce451f4408e157382835f7c52be711e94da'
  version '0.0.1755576355'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755576355/amp-darwin-arm64.zip'
      sha256 '43d414867295d04be30ed272cab1fce451f4408e157382835f7c52be711e94da'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755576355/amp-darwin-x64.zip'
      sha256 'c190c12a097ac14069624ba0d04271eca7815e7fdd9c760b16d50a2d07a1a579'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755576355/amp-linux-arm64'
      sha256 '009a5077bfdaea0e4c65306b012d0dab3f3b97abbdf10ef018a4b4077c6e75c3'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755576355/amp-linux-x64'
      sha256 '276609786ed52eb4339e7298a60915ea7dafdb27fb37389b8e0b157b03e6a5c8'
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
