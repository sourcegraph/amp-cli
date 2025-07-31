# frozen_string_literal: true

# Amp CLI - AI-powered coding assistant
class Amp < Formula
  desc 'Amp CLI - AI-powered coding assistant'
  homepage 'https://github.com/sourcegraph/amp-packages'
  url 'https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753977981-g14e5bc/amp-darwin-arm64'
  sha256 '819e893b8eec9ba3240f93ff231a96fe471f183844be3cd02b2c4b4c9cfe8225'
  version '0.0.1753977981-g14e5bc'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753977981-g14e5bc/amp-darwin-arm64'
      sha256 '819e893b8eec9ba3240f93ff231a96fe471f183844be3cd02b2c4b4c9cfe8225'
    else
      url 'https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753977981-g14e5bc/amp-darwin-x64'
      sha256 '73c1e9b46aba31ce2ff938b2d5d19a01d76338241b40cfa225a11d9d88761e77'
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
