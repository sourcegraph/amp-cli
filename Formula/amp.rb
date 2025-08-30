# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756555607/amp-darwin-arm64.zip'
  sha256 '06266784b915e2dfa50c8c5cdb1e63d291fb168cc6ceb78ad95a65caec979818'
  version '0.0.1756555607'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756555607/amp-darwin-arm64.zip'
      sha256 '06266784b915e2dfa50c8c5cdb1e63d291fb168cc6ceb78ad95a65caec979818'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756555607/amp-darwin-x64.zip'
      sha256 '40d2bd059ed541b6300e0cbd38deea4f2afe0b29540d3c807881f60c5b870f64'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756555607/amp-linux-arm64'
      sha256 '1309e53f5645c25d86dbe759e2029f975c94155ed6df54fe06545e9bab91180f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756555607/amp-linux-x64'
      sha256 '9b9bf48ce84ad8fb12bf0ad7a56dbbe3629552f4f55a878fd793c9d67b1a59ee'
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
