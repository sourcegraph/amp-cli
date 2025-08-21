# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755773580/amp-darwin-arm64.zip'
  sha256 '8caabebc1de72cc8a667f92215c2fc522659c566d5606be8d5f8c564c280ebf4'
  version '0.0.1755773580'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755773580/amp-darwin-arm64.zip'
      sha256 '8caabebc1de72cc8a667f92215c2fc522659c566d5606be8d5f8c564c280ebf4'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755773580/amp-darwin-x64.zip'
      sha256 '92e7b42f0ceb123430e903af3878da9d66010173ec42f2a1eb264685bd63e5ea'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755773580/amp-linux-arm64'
      sha256 'fa327f984ab11a538e24458d589885380d104ad0514617740d2e59f419c6634a'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755773580/amp-linux-x64'
      sha256 '8d86f33fe6657934212adf0782f16683d39971aff54c9d56b92d4dbc24c3fd78'
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
