# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755763621/amp-darwin-arm64.zip'
  sha256 '2163acb657e904daafd48fd55fc57d1dcf46fcb600864a7f723b95eb70c6b799'
  version '0.0.1755763621'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755763621/amp-darwin-arm64.zip'
      sha256 '2163acb657e904daafd48fd55fc57d1dcf46fcb600864a7f723b95eb70c6b799'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755763621/amp-darwin-x64.zip'
      sha256 'f984cab3523a66933bc18ae053d58181df1f39e4af0eb69e9610e13e24f3b8d6'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755763621/amp-linux-arm64'
      sha256 '23af627948ae0ae662bfabff5e0b91c5d52c8e75a4768be507e8165bfe7b949c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755763621/amp-linux-x64'
      sha256 '3b33d194e09cbcf56482faad01e5a55a6adb195481cba9b5a28394bea3b348df'
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
