# frozen_string_literal: true

# Amp CLI - AI-powered coding assistant
class Amp < Formula
  desc 'Amp CLI - AI-powered coding assistant'
  homepage 'https://github.com/sourcegraph/amp-packages'
  url '        https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753982703-gda0d4e/amp-darwin-arm64'
  sha256 'a2a13bd0c4659fd400b0cfabf4d0d638d92efd3ae0da5eb312dbe90d58441e12'
  version '0.0.1753977981-g14e5bc'

  on_macos do
    if Hardware::CPU.arm?
      url '        https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753982703-gda0d4e/amp-darwin-arm64'
      sha256 'a2a13bd0c4659fd400b0cfabf4d0d638d92efd3ae0da5eb312dbe90d58441e12'
    else
      url '        https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753982703-gda0d4e/amp-darwin-x64'
      sha256 'e997bffdc6314c1d497b6f7a9a572f27f5e65d04bdc5556bfbf90136f61414dc'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url '        https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753982703-gda0d4e/amp-linux-arm64'
      sha256 'REPLACE_WITH_PLACEHOLDER'
    else
      url '        https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753982703-gda0d4e/amp-linux-x64'
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
