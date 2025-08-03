# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754251511/amp-darwin-arm64.zip'
  sha256 'e2feef50710d08437bd1fb3d9bceba0dcd23923faf0f1470b01b3952ded4dc12'
  version '0.0.1754251511'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754251511/amp-darwin-arm64.zip'
      sha256 'e2feef50710d08437bd1fb3d9bceba0dcd23923faf0f1470b01b3952ded4dc12'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754251511/amp-darwin-x64.zip'
      sha256 'aad6889353e42a58e5bd9ba59d229792508748e35a50f1f101cdac9611156676'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754251511/amp-linux-arm64'
      sha256 '8d9ab1bdbb466a7f925653ec44f31ab809ca3b6d2c4cf96182b4ceeee0e79b69'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754251511/amp-linux-x64'
      sha256 '5f9d909837cd40469db7b29a565aed91686dd48ae3947b160d0c84e28f131920'
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
