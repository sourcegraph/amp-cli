# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754353238/amp-darwin-arm64.zip'
  sha256 'ab7f1112515a52ae2a3f1c39f16ba068a0f0e40cf8cb1fce5a3e561305d9327e'
  version '0.0.1754353238'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754353238/amp-darwin-arm64.zip'
      sha256 'ab7f1112515a52ae2a3f1c39f16ba068a0f0e40cf8cb1fce5a3e561305d9327e'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754353238/amp-darwin-x64.zip'
      sha256 '3d233dcb56d18176d4d11f06a75da6cc666ed1485c8749695be5e9400a7a01bb'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754353238/amp-linux-arm64'
      sha256 '3dcd4840bde4b5b00711b6cdc8441426ee0ae9c89489548512772c6774f928cd'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754353238/amp-linux-x64'
      sha256 '9bb21729fd6fc2113dbdca971b69e88a0874ea505cfe6e5681891511ad2573b4'
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
