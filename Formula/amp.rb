# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755331562/amp-darwin-arm64.zip'
  sha256 '1f0f4d6a9932eec58c07971042728a4348f2aa547b8f03482509e896e9ea8ad5'
  version '0.0.1755331562'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755331562/amp-darwin-arm64.zip'
      sha256 '1f0f4d6a9932eec58c07971042728a4348f2aa547b8f03482509e896e9ea8ad5'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755331562/amp-darwin-x64.zip'
      sha256 'caa825c7022e7327ecbdc50e69272bb31d97e4c09d403812d4ca0a8c3e0982d4'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755331562/amp-linux-arm64'
      sha256 '7a491d5826f6ce29d21c769df16aa244df43fbaf15afcb623269ff3e44cc0e24'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755331562/amp-linux-x64'
      sha256 'bb664f87f2c156e7da3e68a130f3a04a4360c8b68dd97630628790f44a58e1e4'
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
