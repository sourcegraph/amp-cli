# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755014726/amp-darwin-arm64.zip'
  sha256 '437e86a03cb9aa76459f8d80f04282f65e7d965634f61ae94e2bdd23dc76d62c'
  version '0.0.1755014726'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755014726/amp-darwin-arm64.zip'
      sha256 '437e86a03cb9aa76459f8d80f04282f65e7d965634f61ae94e2bdd23dc76d62c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755014726/amp-darwin-x64.zip'
      sha256 '663c77dd475de84c9e83e8cc76cd24647eedbca2776bc4cffb5dfca5927f5583'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755014726/amp-linux-arm64'
      sha256 'f9e32ea35def9d72eb3db9dba020e801541aa86fe138a7cde36bd3442449063b'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755014726/amp-linux-x64'
      sha256 'dd9a096187215cb4ee322b4b9577958160b1692a016cd7affb1ad9fee76e4828'
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
