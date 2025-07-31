# frozen_string_literal: true

# Amp CLI - AI-powered coding assistant
class Amp < Formula
  desc 'Amp CLI - AI-powered coding assistant'
  homepage 'https://github.com/sourcegraph/amp-packages'
  url '          https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753985789-gda0d4e/amp-darwin-arm64'
  sha256 'da71ce4c2822c6827a5ea71ab031b4c112dcaa1a8d4002129cbbec14ae2bf42c'
  version '0.0.1753985789-gda0d4e'

  on_macos do
    if Hardware::CPU.arm?
      url '          https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753985789-gda0d4e/amp-darwin-arm64'
      sha256 'da71ce4c2822c6827a5ea71ab031b4c112dcaa1a8d4002129cbbec14ae2bf42c'
    else
      url '          https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753985789-gda0d4e/amp-darwin-x64'
      sha256 'a7d60dce6a5d17f4e7442a58e1354c489d38b1a03908cda642404bcc337a73e6'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url '          https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753985789-gda0d4e/amp-linux-arm64'
      sha256 '64a985094e21ebb1306a56da5a2b443f19fe629f489bf9840eef14edc2d073df'
    else
      url '          https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753985789-gda0d4e/amp-linux-x64'
      sha256 'd1fa512f3e6ab2a82ac8886746cd7549231cd7aaf6d7db05352c211e6408cf9b'
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
