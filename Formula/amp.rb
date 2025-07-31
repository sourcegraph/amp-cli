# frozen_string_literal: true

# Amp CLI - AI-powered coding assistant
class Amp < Formula
  desc 'Amp CLI - AI-powered coding assistant'
  homepage 'https://github.com/sourcegraph/amp-packages'
  url 'https://github.com/sourcegraph/amp-packages/releases/download/v1.0.0/amp-darwin-arm64'
  sha256 'REPLACE_WITH_DARWIN_ARM64_SHA256'
  version '1.0.0'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://github.com/sourcegraph/amp-packages/releases/download/v1.0.0/amp-darwin-arm64'
      sha256 'REPLACE_WITH_DARWIN_ARM64_SHA256'
    else
      url 'https://github.com/sourcegraph/amp-packages/releases/download/v1.0.0/amp-darwin-x64'
      sha256 'REPLACE_WITH_DARWIN_AMD64_SHA256'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/sourcegraph/amp-packages/releases/download/v1.0.0/amp-linux-arm64'
      sha256 'REPLACE_WITH_LINUX_ARM64_SHA256'
    else
      url 'https://github.com/sourcegraph/amp-packages/releases/download/v1.0.0/amp-linux-x64'
      sha256 'REPLACE_WITH_LINUX_AMD64_SHA256'
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
