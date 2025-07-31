# frozen_string_literal: true

# Amp CLI - AI-powered coding assistant
class Amp < Formula
  desc 'Amp CLI - AI-powered coding assistant'
  homepage 'https://github.com/sourcegraph/amp-packages'
  url 'https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753977981-g14e5bc/amp-darwin-arm64'
  sha256 'fdde66b16860a824fe59d5eb8961ed8b5c16dcb717b43a1078e27278821fecec'
  version '0.0.1753977981-g14e5bc'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753977981-g14e5bc/amp-darwin-arm64'
      sha256 'fdde66b16860a824fe59d5eb8961ed8b5c16dcb717b43a1078e27278821fecec'
    else
      url 'https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753977981-g14e5bc/amp-darwin-x64'
      sha256 '349ac473187ae27466708e7e1aa4d3ad3fe9ed0343bedb5c930bc3a5bb2a853e'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753977981-g14e5bc/amp-linux-arm64'
      sha256 'REPLACE_WITH_PLACEHOLDER'
    else
      url 'https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753977981-g14e5bc/amp-linux-x64'
      sha256 'REPLACE_WITH_PLACEHOLDER'
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
