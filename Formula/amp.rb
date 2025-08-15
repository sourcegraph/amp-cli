# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755259667/amp-darwin-arm64.zip'
  sha256 '7068ecf018543ed69c25d62533cba2513d0a71a42d38e844713fb2941a2a03a3'
  version '0.0.1755259667'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755259667/amp-darwin-arm64.zip'
      sha256 '7068ecf018543ed69c25d62533cba2513d0a71a42d38e844713fb2941a2a03a3'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755259667/amp-darwin-x64.zip'
      sha256 '364f12afa510df96c40db99b3c3016b0bcf197f16d282257130765999652880b'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755259667/amp-linux-arm64'
      sha256 'bfbc81821107499f3bd10a5974c508fb4383c677dcb179df6ed6b18e8d72ea7d'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755259667/amp-linux-x64'
      sha256 '9c7d88a4f46072c0995dc292474cbbabfd1aa044be4e6a7dbb3444f7eaf2e0c2'
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
