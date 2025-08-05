# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754395724/amp-darwin-arm64.zip'
  sha256 '7be4f7c377a66e379361bf7abf7c18f76534e216d18497b37742b2b5b5b4db58'
  version '0.0.1754395724'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754395724/amp-darwin-arm64.zip'
      sha256 '7be4f7c377a66e379361bf7abf7c18f76534e216d18497b37742b2b5b5b4db58'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754395724/amp-darwin-x64.zip'
      sha256 '8e3799396b379f40734ffcffa02bd1b36fc50a8d8567d0b3e64e04438a1c4d99'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754395724/amp-linux-arm64'
      sha256 'fe9a8012f244c7809f95b1d53d87260dd2633fa8dc7e1f450117680fc3e448dc'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754395724/amp-linux-x64'
      sha256 '23a7da9cfeb83ac4d2bb3fd8102666b7417d489bacab9f20b4e0a7bb374f7cea'
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
