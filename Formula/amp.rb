# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755231076/amp-darwin-arm64.zip'
  sha256 '088563ce12eb2c358ef5b8b03e7dffb9a5fd05175daa96ddea8543784a643d19'
  version '0.0.1755231076'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755231076/amp-darwin-arm64.zip'
      sha256 '088563ce12eb2c358ef5b8b03e7dffb9a5fd05175daa96ddea8543784a643d19'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755231076/amp-darwin-x64.zip'
      sha256 'ad8584983075a083e5c6a58be9b545e1fec7a0298d69cb6eb4c6f6611170f3fc'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755231076/amp-linux-arm64'
      sha256 '7c90cbb0c332bde73613d2d1bcd30a1e0e53863f9a91cb3b9634d08b79ac2b89'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755231076/amp-linux-x64'
      sha256 '2db9c4cf7411b45e14eb6359ef1dcbe0adafef3e5246788f6cfafb4c49c02a9a'
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
