# frozen_string_literal: true

# Amp CLI - AI-powered coding assistant
class Amp < Formula
  desc 'Amp CLI - AI-powered coding assistant'
  homepage 'https://github.com/sourcegraph/amp-packages'
  url '              https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753986405-gda0d4e/amp-darwin-arm64'
  sha256 'c94ae9d1da9ba87c4b3e305399b8f59a4ebfa4d08d1a16592eb30cb956a1874c'
  version '0.0.1753986405-gda0d4e'

  on_macos do
    if Hardware::CPU.arm?
      url '              https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753986405-gda0d4e/amp-darwin-arm64'
      sha256 'c94ae9d1da9ba87c4b3e305399b8f59a4ebfa4d08d1a16592eb30cb956a1874c'
    else
      url '              https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753986405-gda0d4e/amp-darwin-x64'
      sha256 'eb4c53638be696d897357802d14c6d8b8ad6ec2de2cc7d919ca8ffc5c594eca7'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url '              https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753986405-gda0d4e/amp-linux-arm64'
      sha256 'dd6da04d3841826d821419c6b912fba3a5239722d03c9d2ca452476c6f01f657'
    else
      url '              https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753986405-gda0d4e/amp-linux-x64'
      sha256 '14b502ed7b2bee65473cb907b1caf17e7ff2a9baa90030c4381709aeccfddf10'
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
