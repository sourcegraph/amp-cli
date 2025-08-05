# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754357065/amp-darwin-arm64.zip'
  sha256 '64aac790d569252d0ee36e7bd85ec33f8de89a7757083211611ebe9541b6898d'
  version '0.0.1754357065'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754357065/amp-darwin-arm64.zip'
      sha256 '64aac790d569252d0ee36e7bd85ec33f8de89a7757083211611ebe9541b6898d'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754357065/amp-darwin-x64.zip'
      sha256 '88815c6c900287bf607113dec628c30c8f1f4f86dc5f9bce0db72a15e2f7c42c'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754357065/amp-linux-arm64'
      sha256 '9d21876f26d80dd034cd3368431220b4fb3576491933b5f2c0a5925a8c316013'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754357065/amp-linux-x64'
      sha256 '6a4686e207009556a2893281bfc579d87889fc60d6baef98f30dcc15cde4d44c'
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
