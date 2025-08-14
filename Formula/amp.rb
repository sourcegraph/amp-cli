# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755187564/amp-darwin-arm64.zip'
  sha256 '2690262a7a32153a97aeb4233d6df759febb4c6add35aacd1fb6f8be4e9b98c8'
  version '0.0.1755187564'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755187564/amp-darwin-arm64.zip'
      sha256 '2690262a7a32153a97aeb4233d6df759febb4c6add35aacd1fb6f8be4e9b98c8'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755187564/amp-darwin-x64.zip'
      sha256 'b1777f7610712d6c99813d30a2b089bf7dfb9ab5e53a5325d267d807ea29809b'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755187564/amp-linux-arm64'
      sha256 'e6b49a3610780d7711c7e7e797e2dce31469055a0a64bb010bd07ac6c1b64113'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755187564/amp-linux-x64'
      sha256 'd769ca086ce1de1f2518dde8dd5accee45d928bb166caae02c9f7930b51150bf'
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
