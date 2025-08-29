# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756483514/amp-darwin-arm64.zip'
  sha256 '38da1547d2b8857e1395405e22188fb1e027e839d8784432d524a3dd9b1c3af2'
  version '0.0.1756483514'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756483514/amp-darwin-arm64.zip'
      sha256 '38da1547d2b8857e1395405e22188fb1e027e839d8784432d524a3dd9b1c3af2'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756483514/amp-darwin-x64.zip'
      sha256 'd1b710c1c4b76b975831eceb3ac634fcf4bd8c65592a2acabe2b2aa40517f066'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756483514/amp-linux-arm64'
      sha256 '51a6fc36c156752b55fb6cdce1bfa5e316d4a8a466a17d67d40f5530216f449b'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756483514/amp-linux-x64'
      sha256 '663cf1ddb7075df634b78710363f4c450962c8419b0380789af312faef3220ac'
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
