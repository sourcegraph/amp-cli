# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754785296/amp-darwin-arm64.zip'
  sha256 'aacb2513fbb4dbcdbcc689f26a6ba50252bebdd9ac96fa6a2ca1b84b2cbd26e9'
  version '0.0.1754785296'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754785296/amp-darwin-arm64.zip'
      sha256 'aacb2513fbb4dbcdbcc689f26a6ba50252bebdd9ac96fa6a2ca1b84b2cbd26e9'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754785296/amp-darwin-x64.zip'
      sha256 'cd3a0596d6462ec77e0f83ea3d2e4b190814e116c71f861407d6ce5f42a39a55'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754785296/amp-linux-arm64'
      sha256 '127b5c1348e12f0693c115d3c887ddf8f3adb6a4f85649a7d6081ce3a79f91c3'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754785296/amp-linux-x64'
      sha256 '3196fc4d4bf30e7c7f227b5870ef0e3acaa77bfff97faca2b98197ab8417fd51'
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
