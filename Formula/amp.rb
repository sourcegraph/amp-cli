# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756152334/amp-darwin-arm64.zip'
  sha256 'e6c785e76c3854dc7526b6793c59e25f05c2868d27c769839fc0d845f463b4d8'
  version '0.0.1756152334'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756152334/amp-darwin-arm64.zip'
      sha256 'e6c785e76c3854dc7526b6793c59e25f05c2868d27c769839fc0d845f463b4d8'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756152334/amp-darwin-x64.zip'
      sha256 '1801fe6c6ec8e6091a8ade4fde610308854bbf81b1b26e6a5a3b391e6eb3d18b'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756152334/amp-linux-arm64'
      sha256 '4dea2570720a1af1220bc0406405687b218d9a03aa492aaaeabf17c66a93225b'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756152334/amp-linux-x64'
      sha256 '7b9d4092d0c602ba759811d827e74d64a41c5aa77c067a2fbef5c89693e67d35'
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
