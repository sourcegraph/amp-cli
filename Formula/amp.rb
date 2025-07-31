# frozen_string_literal: true

# Amp CLI - AI-powered coding assistant
class Amp < Formula
  desc 'Amp CLI - AI-powered coding assistant'
  homepage 'https://github.com/sourcegraph/amp-packages'
  url 'https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753977981-g14e5bc/amp-darwin-arm64'
  sha256 'e697985367883f64a24f4c061bd0e10412fded6755de6ba1f6b8a54b9e10d281'
  version '0.0.1753977981-g14e5bc'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753977981-g14e5bc/amp-darwin-arm64'
      sha256 'e697985367883f64a24f4c061bd0e10412fded6755de6ba1f6b8a54b9e10d281'
    else
      url 'https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753977981-g14e5bc/amp-darwin-x64'
      sha256 '637a9c7b12a95bfa1f728fd2f3e894b4d9e8538c3d41350264e574889024cfb2'
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
