# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754957954/amp-darwin-arm64.zip'
  sha256 '17ec3e7fece42bea7976e76672973761f1d87fe28942d4f611ce2be9af6ab418'
  version '0.0.1754957954'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754957954/amp-darwin-arm64.zip'
      sha256 '17ec3e7fece42bea7976e76672973761f1d87fe28942d4f611ce2be9af6ab418'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754957954/amp-darwin-x64.zip'
      sha256 '085191dcb08bb50d77ce7d127e68ea9326a7273747efdaf5100ff903fcae6757'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754957954/amp-linux-arm64'
      sha256 '5cb316faf3e1e853a7000e36e540509170d546c3073654c4ce3b6793df7bbfe5'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754957954/amp-linux-x64'
      sha256 '27c37cfc76cf7bb6445bfb9c42f13e38c34252e95081d516292f6baadfe4fdf1'
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
