# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754215122/amp-darwin-arm64.zip'
  sha256 'ecae8432e26f53da15a8802d9f7809f19d10c6713b461bdbc3945a76e17cfcba'
  version '0.0.1754215122'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754215122/amp-darwin-arm64.zip'
      sha256 'ecae8432e26f53da15a8802d9f7809f19d10c6713b461bdbc3945a76e17cfcba'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754215122/amp-darwin-x64.zip'
      sha256 'a4f2c53664b920621488b8056a254257dfcc97a9e44314c0f4be8af1db60a311'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754215122/amp-linux-arm64'
      sha256 '227b8913b2f1f4ce1ab865204ad76cc5f4d1b64232c61cef9bac213061f34efb'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754215122/amp-linux-x64'
      sha256 '9d92fdcf1b51ce7ed0a6311f3a7437134e708983de37f809c7618a56b1892aed'
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
