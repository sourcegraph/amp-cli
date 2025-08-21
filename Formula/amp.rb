# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755792316/amp-darwin-arm64.zip'
  sha256 'ddbb0025da5dfa094062c2ac580cac37a77ff8ec333ac70b49e54839347dbc35'
  version '0.0.1755792316'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755792316/amp-darwin-arm64.zip'
      sha256 'ddbb0025da5dfa094062c2ac580cac37a77ff8ec333ac70b49e54839347dbc35'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755792316/amp-darwin-x64.zip'
      sha256 '1d7c33c2b43821d7f3f5420bc51afc12563ddd17ab738fed85aa8c786cc88650'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755792316/amp-linux-arm64'
      sha256 '8cf40006d62830c5d2a994be1929fcfc8b30a8f03fb0eff9953f6df2ed74410e'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755792316/amp-linux-x64'
      sha256 '689d0a93be74f84b32db0d33b0dcb8fc4d448a6f467f3b9c9e00b67ed2ca9ed3'
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
