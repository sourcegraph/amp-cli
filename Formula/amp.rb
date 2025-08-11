# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754886038/amp-darwin-arm64.zip'
  sha256 '71ad210a34ed9a70591184774a3f489e18a3f5eea07db693c8b2d2d7879ea75f'
  version '0.0.1754886038'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754886038/amp-darwin-arm64.zip'
      sha256 '71ad210a34ed9a70591184774a3f489e18a3f5eea07db693c8b2d2d7879ea75f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754886038/amp-darwin-x64.zip'
      sha256 '3f6ebf80147e6f8be0797ae31e9d9de2c630fdcdfae4e4d70d0bfacf11a21697'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754886038/amp-linux-arm64'
      sha256 '6182a0432ab5ab44816bd4efa6f2a5f9fc1f445e74eaf375cad14cfdc0c44d9b'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754886038/amp-linux-x64'
      sha256 'f4af7fbf5761e4d9eb62f4be040795ce3e6165c574236ded5cab1fb348876254'
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
