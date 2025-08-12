# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755029121/amp-darwin-arm64.zip'
  sha256 'ca858b9a4db2c49d427bcdbfa2ce62fb0af0093c30f9ab4040fae42f955b95e0'
  version '0.0.1755029121'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755029121/amp-darwin-arm64.zip'
      sha256 'ca858b9a4db2c49d427bcdbfa2ce62fb0af0093c30f9ab4040fae42f955b95e0'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755029121/amp-darwin-x64.zip'
      sha256 '0877d95a2ef315aa83aad34b5adf74d2f4c581e2c257a90928b574c480de2313'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755029121/amp-linux-arm64'
      sha256 'd626178d3ccf892dfa9230dd7ba2b056825f77ce5a929f06e111ac3d5f74ddab'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755029121/amp-linux-x64'
      sha256 'ddf1a0c1e614fc2a99afcab9232ee5d350660e97f3f96436fe709ceea7472868'
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
