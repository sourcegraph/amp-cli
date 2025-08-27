# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756267539/amp-darwin-arm64.zip'
  sha256 '185f485b0cd54c5635707942b7db07df292fe47ee296a8632668f2a1fda95a9b'
  version '0.0.1756267539'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756267539/amp-darwin-arm64.zip'
      sha256 '185f485b0cd54c5635707942b7db07df292fe47ee296a8632668f2a1fda95a9b'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756267539/amp-darwin-x64.zip'
      sha256 '514bc0b9e07bf90c4b6bc0a3068302d0d0907d3fe43fc9570da37ced99df9322'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756267539/amp-linux-arm64'
      sha256 '775f9b89e0be5b44b4027cfcd448c31203b14b3a6eaa72db4d3a33e49561c32c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756267539/amp-linux-x64'
      sha256 'b0d60409b60b8da24c1ac547842dd89e06bdddc798956217c474a44cdcdf4524'
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
