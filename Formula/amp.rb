# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755965097/amp-darwin-arm64.zip'
  sha256 '5ccf7dbb52966db3e1306f3b2eb2529b68db25999fc01a9af442de84d96b8391'
  version '0.0.1755965097'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755965097/amp-darwin-arm64.zip'
      sha256 '5ccf7dbb52966db3e1306f3b2eb2529b68db25999fc01a9af442de84d96b8391'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755965097/amp-darwin-x64.zip'
      sha256 'e529aa96539a25a09c2cec318c8ddbe71b5dde5510af884350f1b002f46273d3'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755965097/amp-linux-arm64'
      sha256 '7e1002b71e30b0abb7a5e47a8db9089e1f09be81c915965c3cefa8320e87e74d'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755965097/amp-linux-x64'
      sha256 'da31ce24d47ca8e095d2b263b3cfb8d3f14264fe975a34e022bbcf9e0eebfd38'
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
