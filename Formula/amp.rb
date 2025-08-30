# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756541136/amp-darwin-arm64.zip'
  sha256 '11ec147c4ddf83aeb6116bc403b62d972ebf2b66ef8826a2c9e6721e765905ff'
  version '0.0.1756541136'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756541136/amp-darwin-arm64.zip'
      sha256 '11ec147c4ddf83aeb6116bc403b62d972ebf2b66ef8826a2c9e6721e765905ff'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756541136/amp-darwin-x64.zip'
      sha256 'dfe8efe7ac4a2ff5f04aa897d5c21a05671cda1c716d710683833e4b1f621082'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756541136/amp-linux-arm64'
      sha256 'f2936ac88eb90ec98c6b2158a6e33e6e2b46a85342c9718871a8611f6cad904a'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756541136/amp-linux-x64'
      sha256 'ee760762639c4118a8dbb93a8f45dd7f56cdabfebd8953191a812dd43b4392bc'
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
