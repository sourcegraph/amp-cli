# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755864451/amp-darwin-arm64.zip'
  sha256 'd142b5ac6c28069c987db07935227b63daad72ed9ec0c4b0400f57500c176b39'
  version '0.0.1755864451'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755864451/amp-darwin-arm64.zip'
      sha256 'd142b5ac6c28069c987db07935227b63daad72ed9ec0c4b0400f57500c176b39'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755864451/amp-darwin-x64.zip'
      sha256 '9bbc7e78552f16e59c980a4230722405d6bd43fc09ab20b5804494de9fabab1b'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755864451/amp-linux-arm64'
      sha256 'e352dfa1f7ada46bd01dd89f8506558316f9485092c1736c948ba980c81f9d7f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755864451/amp-linux-x64'
      sha256 '320af8f6cb365d05e859b22c3a6820ced42d8cc398c6704db3d54798b3942873'
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
