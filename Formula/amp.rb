# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755590790/amp-darwin-arm64.zip'
  sha256 '196171d018f32278b7d0c3feb779388e0c1a6385958c4540a0f46cbf0737d8be'
  version '0.0.1755590790'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755590790/amp-darwin-arm64.zip'
      sha256 '196171d018f32278b7d0c3feb779388e0c1a6385958c4540a0f46cbf0737d8be'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755590790/amp-darwin-x64.zip'
      sha256 '6019b10a5ca5fdb4bce60c6bb47fe0d91191f3b2a37d36fdca16ad2d932a5c1f'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755590790/amp-linux-arm64'
      sha256 'da97872a1b5d5f6f954a6a264f27c1e851897356cf0d1281e9bda92a0ad57057'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755590790/amp-linux-x64'
      sha256 '4882e9f966d0f8febf049221b639fa519a4372d1f572402fe977ef07a3865c8b'
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
