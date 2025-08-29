# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756469269/amp-darwin-arm64.zip'
  sha256 'd1d766e715be48dbe5c459c18efa8361b2fc69a0d677b211742f1672ba17b993'
  version '0.0.1756469269'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756469269/amp-darwin-arm64.zip'
      sha256 'd1d766e715be48dbe5c459c18efa8361b2fc69a0d677b211742f1672ba17b993'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756469269/amp-darwin-x64.zip'
      sha256 'b7d6590ae6ccfa1babbeb1f2517299b71c102062c92d9c5fecb4270ad199d70a'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756469269/amp-linux-arm64'
      sha256 'd013f9910cdb77e7f84a93d863883b148b027b18b1e6f5c3e70883a6bdaee36d'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756469269/amp-linux-x64'
      sha256 '0b24ac4d907f54c55652066078a86c7b1471219ffb863160813c23b06fc8d820'
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
