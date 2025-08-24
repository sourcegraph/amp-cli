# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756022739/amp-darwin-arm64.zip'
  sha256 '8cf70f775af3276ab09bbaea87c8c898e81e834dbf27bcb830ca617537575eb1'
  version '0.0.1756022739'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756022739/amp-darwin-arm64.zip'
      sha256 '8cf70f775af3276ab09bbaea87c8c898e81e834dbf27bcb830ca617537575eb1'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756022739/amp-darwin-x64.zip'
      sha256 '0d96af1a32a19b73b4e78610d1c574482cf0d3e29137e646db7a5e96d22b9eea'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756022739/amp-linux-arm64'
      sha256 '146fd0f961eb2e769ee830298869aa7ad44ff596f2143d0158a04ac448a76a75'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756022739/amp-linux-x64'
      sha256 '998cba2b188e1d3296e82d374ffb46a49994bdc94635c9d94cae28bd451dd73e'
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
