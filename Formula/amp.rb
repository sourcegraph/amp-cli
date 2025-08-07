# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754597131/amp-darwin-arm64.zip'
  sha256 '3ded2c2c3b898510b21247bb134f361ec88e0086f7fad06fd5cfe89f5592c879'
  version '0.0.1754597131'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754597131/amp-darwin-arm64.zip'
      sha256 '3ded2c2c3b898510b21247bb134f361ec88e0086f7fad06fd5cfe89f5592c879'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754597131/amp-darwin-x64.zip'
      sha256 '32f8ed0238dfbce18830b728251fef6e0d4b6adb3a73980c963f5dbe596146f4'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754597131/amp-linux-arm64'
      sha256 'a069b6f732c06f04a1ce78fd58ff44b20c83eff81299b8f4a9fe7fb11a24cc5c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754597131/amp-linux-x64'
      sha256 '4f3057048338c43c0bf11f77cd4d5e7949ae821d799170040b90159863266a4b'
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
