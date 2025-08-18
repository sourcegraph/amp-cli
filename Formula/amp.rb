# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755490705/amp-darwin-arm64.zip'
  sha256 'fb67e93f97130287a2c6c32748382f0dac4c4d109c5db9ba9d846fadc38efe87'
  version '0.0.1755490705'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755490705/amp-darwin-arm64.zip'
      sha256 'fb67e93f97130287a2c6c32748382f0dac4c4d109c5db9ba9d846fadc38efe87'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755490705/amp-darwin-x64.zip'
      sha256 '4e46a8a599a7f8864e75d9405cf57af488bceae215c89c96927433656bf2acc0'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755490705/amp-linux-arm64'
      sha256 'd25701ff53b4cc60a31284536326047f2127aef8762663e6dc71ed78d12e6e71'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755490705/amp-linux-x64'
      sha256 '95bed4f456b0699390bc535b3f4d54e3910c7343b606a232c3266e16d4fee920'
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
