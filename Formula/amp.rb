# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756195602/amp-darwin-arm64.zip'
  sha256 '0f34b279509b09071a36b3e3cd5e0acaf4979ee3ae4cbf424228e40f22d7be01'
  version '0.0.1756195602'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756195602/amp-darwin-arm64.zip'
      sha256 '0f34b279509b09071a36b3e3cd5e0acaf4979ee3ae4cbf424228e40f22d7be01'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756195602/amp-darwin-x64.zip'
      sha256 '0af7a5488f21c6c8035850f92b32a4d3f7f20906e63cb75bc1640c49964085d5'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756195602/amp-linux-arm64'
      sha256 '6a825fdd3cb8400e8630cee556846a84f29f413ba040f89ea51224a2fb71bb73'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756195602/amp-linux-x64'
      sha256 '61e7ec73e946966c9f424925e34af2ae0e115bdd19d3575f5e9d0be1bdc39846'
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
