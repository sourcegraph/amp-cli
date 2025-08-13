# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755101090/amp-darwin-arm64.zip'
  sha256 '488fc8d02b2bd7da100e71ddc766c26829934d9e3a8318ad238ba25982b70576'
  version '0.0.1755101090'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755101090/amp-darwin-arm64.zip'
      sha256 '488fc8d02b2bd7da100e71ddc766c26829934d9e3a8318ad238ba25982b70576'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755101090/amp-darwin-x64.zip'
      sha256 '800093696d93aaa0dd5c220768a8eace892c25a135b63b41ef1635353887dc75'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755101090/amp-linux-arm64'
      sha256 '944fa9ccd4799e9113bb9fe01c261d50640fb7f23914f3d0c94a9b79c7848b5c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755101090/amp-linux-x64'
      sha256 'f44eb4796df607c3c6c9ba02977fbfa8724f1f5253d8cb512183df245592afe2'
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
