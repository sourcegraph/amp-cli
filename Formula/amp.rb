# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756210085/amp-darwin-arm64.zip'
  sha256 '36133ca6797952285fd0e75050718fed404a9a1a62ac9ff7fe05d77b96263f2f'
  version '0.0.1756210085'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756210085/amp-darwin-arm64.zip'
      sha256 '36133ca6797952285fd0e75050718fed404a9a1a62ac9ff7fe05d77b96263f2f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756210085/amp-darwin-x64.zip'
      sha256 '0f2893d39780f6caf7715000f0cd5361509ca95e4b0315f9e08be07f4a1515df'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756210085/amp-linux-arm64'
      sha256 'ae727827388bb35e7511e5faa0f91402db0aa16ff2476de1191673da07fc1cca'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756210085/amp-linux-x64'
      sha256 'bbca8b9108aa5f3df7cec84746dcdd9ea967b2efdb3270f02a82e1a487eb6c25'
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
