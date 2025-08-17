# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755432418/amp-darwin-arm64.zip'
  sha256 'd2c596d603e9c905e843ccc967ca43b1c5e5e0b79195588b7726529a2cb8f27d'
  version '0.0.1755432418'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755432418/amp-darwin-arm64.zip'
      sha256 'd2c596d603e9c905e843ccc967ca43b1c5e5e0b79195588b7726529a2cb8f27d'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755432418/amp-darwin-x64.zip'
      sha256 'a9f368326b0432eda5ff7cdc1bba57cd1c2538f007a656a1d94fa751a178697e'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755432418/amp-linux-arm64'
      sha256 'b9051e413979c46b49bdf62f63bb6bcbf66d4341ab41a1f55a5ff9d576d3b801'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755432418/amp-linux-x64'
      sha256 '1e8e3d18808bb2a3a626f710332ba2348b4fbad4fd5dbfb69eadd6d2534fd718'
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
