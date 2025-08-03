# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754208355/amp-darwin-arm64.zip'
  sha256 'bfd21599e6e82edfa7f7367b9ea7e57edb5d7d5018fa8b0186ec626e4bbf6d46'
  version '0.0.1754208355'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754208355/amp-darwin-arm64.zip'
      sha256 'bfd21599e6e82edfa7f7367b9ea7e57edb5d7d5018fa8b0186ec626e4bbf6d46'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754208355/amp-darwin-x64.zip'
      sha256 '00f47cc22cc3efc633dc528b29ce1d402ea1edb66f7c90e5e50a8e58b6afad13'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754208355/amp-linux-arm64'
      sha256 '0b7c82b68c900fa663b7cf156f499ecd6d67b3849034e968ecc5c514f923b5d1'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754208355/amp-linux-x64'
      sha256 'd5ba16f0717236f25fc617d59359d93dc745d2bf28d05771adb4761b8720f9d6'
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
