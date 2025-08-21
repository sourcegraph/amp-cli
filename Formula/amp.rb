# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755806726/amp-darwin-arm64.zip'
  sha256 '31f27733e9f45e41ff77189b3ef1798abd718f10656b870149ab974b89f2813f'
  version '0.0.1755806726'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755806726/amp-darwin-arm64.zip'
      sha256 '31f27733e9f45e41ff77189b3ef1798abd718f10656b870149ab974b89f2813f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755806726/amp-darwin-x64.zip'
      sha256 '25d5a9ee61bd6a41345a7e8c2ceb71565d7d2c576a53c17bb0ba31e3586164be'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755806726/amp-linux-arm64'
      sha256 '2dcc1d350cfc7c95b732c967d00c586997d43f42b6c0df22c2a2b53e26712f5e'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755806726/amp-linux-x64'
      sha256 'c69e48663791794d83c6cb7890fba52e3d5dd5354072d1ec63906180930ef18f'
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
