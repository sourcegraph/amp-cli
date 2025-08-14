# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755130753/amp-darwin-arm64.zip'
  sha256 'ba38362c05d97c6f7cd99f6d843b129bfefc917e395d94d53e1f98922fae1e49'
  version '0.0.1755130753'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755130753/amp-darwin-arm64.zip'
      sha256 'ba38362c05d97c6f7cd99f6d843b129bfefc917e395d94d53e1f98922fae1e49'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755130753/amp-darwin-x64.zip'
      sha256 '8b801e55b4598e59f62122a1dfc3c6780cb8cff3d1e38f8250ccf872fbf78f21'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755130753/amp-linux-arm64'
      sha256 '2761876a9128306a296c5540e6ca2f7700745cd67eb32284dbc147c56d9eb434'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755130753/amp-linux-x64'
      sha256 '83a2376e0e31786926456cce1d32ba4c02519c39a1245c823e2f09f35ce1e87e'
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
