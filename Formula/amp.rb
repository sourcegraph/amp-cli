# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755446689/amp-darwin-arm64.zip'
  sha256 'fbefd01987154dd0b65838dfb58722b5221c247a1912d6a664fe4dc797e451a4'
  version '0.0.1755446689'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755446689/amp-darwin-arm64.zip'
      sha256 'fbefd01987154dd0b65838dfb58722b5221c247a1912d6a664fe4dc797e451a4'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755446689/amp-darwin-x64.zip'
      sha256 '55e1d84eb3edb90769e1ba148ea7436e4cc66b55920fba96099979a27214ead8'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755446689/amp-linux-arm64'
      sha256 'd957c3fe8b97485a186edb6ec8f906ee0db547c2351a1539807b2f0bfa4fca14'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755446689/amp-linux-x64'
      sha256 'fa3d171134f8eb0e94561fe0e599494f6251476ffd04103fec721ea9ec4db154'
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
