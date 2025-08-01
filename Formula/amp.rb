# frozen_string_literal: true

# Amp CLI - AI-powered coding assistant
class Amp < Formula
  desc 'Amp CLI - AI-powered coding assistant'
  homepage 'https://github.com/sourcegraph/amp-packages'
  url '                https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1754007787-g59be4b/amp-darwin-arm64'
  sha256 '3a0b72bbd697d012281b09fb168a3ddbe3413b6dda442d874f425c8b8fb14052'
  version '0.0.1754007787-g59be4b'

  on_macos do
    if Hardware::CPU.arm?
      url '                https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1754007787-g59be4b/amp-darwin-arm64'
      sha256 '3a0b72bbd697d012281b09fb168a3ddbe3413b6dda442d874f425c8b8fb14052'
    else
      url '                https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1754007787-g59be4b/amp-darwin-x64'
      sha256 '3926845c500db822b462f82e831316b5f011e86e144d4e5fc236eac5201197b2'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url '                https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1754007787-g59be4b/amp-linux-arm64'
      sha256 '28a470afae5dd51266f5e7ee5ebfae3051ea2b02277f312e886e57f34d539ac8'
    else
      url '                https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1754007787-g59be4b/amp-linux-x64'
      sha256 '9b49acd0d93a66051877b3153e1b67821c77c5bf54cc388fe9048bb9ce39a098'
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
