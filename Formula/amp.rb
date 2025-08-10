# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754813145/amp-darwin-arm64.zip'
  sha256 'ed308be3f9beb6e3dc74e921197be32cb335fe2f5c601025469adf2c7614250b'
  version '0.0.1754813145'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754813145/amp-darwin-arm64.zip'
      sha256 'ed308be3f9beb6e3dc74e921197be32cb335fe2f5c601025469adf2c7614250b'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754813145/amp-darwin-x64.zip'
      sha256 'd32310d4bd6bde6f8ecce67ce9ee4c68aaa3507eed2eaf4479789e0f5433773f'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754813145/amp-linux-arm64'
      sha256 'ebf6e9b603f9d85005e0df7d2a6ee4821adf2641a3f5dc93232e545993f6df58'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754813145/amp-linux-x64'
      sha256 'f9e2eb4eaf18ed70705781f65dfab9cdaf4f5c9198fd91bfa6413a248bd01f3c'
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
