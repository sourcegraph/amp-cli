# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755921912/amp-darwin-arm64.zip'
  sha256 '0f8e15d5d429b5e3b24f6ff8015dc559ebf45a236ae0a46a54ee0f84c91710f3'
  version '0.0.1755921912'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755921912/amp-darwin-arm64.zip'
      sha256 '0f8e15d5d429b5e3b24f6ff8015dc559ebf45a236ae0a46a54ee0f84c91710f3'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755921912/amp-darwin-x64.zip'
      sha256 '1fb2863a033a2076a50d2f2b0ebe92c941b2e2d9248601d5a299d165b3b991b9'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755921912/amp-linux-arm64'
      sha256 'aae52976c218577be3a68af1e25c45d2bec101838e3e3ad8baabc9634ccc599e'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755921912/amp-linux-x64'
      sha256 '2f334b370abe18293bb480700850691f40ace63c60da980fbc2b6ad39af7b4a8'
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
