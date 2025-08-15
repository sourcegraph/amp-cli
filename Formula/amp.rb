# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755288321/amp-darwin-arm64.zip'
  sha256 '7dd8637bbca7823778a721f519f7458bf6039bee62fb739bb587bcb9176de94f'
  version '0.0.1755288321'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755288321/amp-darwin-arm64.zip'
      sha256 '7dd8637bbca7823778a721f519f7458bf6039bee62fb739bb587bcb9176de94f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755288321/amp-darwin-x64.zip'
      sha256 'b56ee655cb8e9fc2545a65a1f1ca8d144da538898a402adc2e5155347d989a75'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755288321/amp-linux-arm64'
      sha256 '1b97087b19df7d99c62a7748d9574166431bda0745b3098e5f44fa011452db27'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755288321/amp-linux-x64'
      sha256 '5eaae41269c485a3bc1230c73e9b64b47859222eadcc73f8ab45d770b930cede'
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
