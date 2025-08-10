# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754799571/amp-darwin-arm64.zip'
  sha256 '4f5f97e9d670104523e69fc90b017b658beeacc57997eabbd374153f803993cc'
  version '0.0.1754799571'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754799571/amp-darwin-arm64.zip'
      sha256 '4f5f97e9d670104523e69fc90b017b658beeacc57997eabbd374153f803993cc'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754799571/amp-darwin-x64.zip'
      sha256 'd380d0849c8fbd3ef42417299193d2f76077b0a5e014de0dee06c3c30c93792e'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754799571/amp-linux-arm64'
      sha256 '4d51b0a942f1d51cd4a1e67c9c0b354ebc4dfb0e7b2ee9e2154858cec989413d'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754799571/amp-linux-x64'
      sha256 '75484cdbca667d7b42cfaf2d2ebfabcdd86b3a2846e45d8778826ab19342b99e'
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
