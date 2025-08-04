# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754323597/amp-darwin-arm64.zip'
  sha256 '81c6a4b9f73575ae157bd1dca9aa7bd7f68a744dfa5ba988f4c78e7cc6dfa587'
  version '0.0.1754323597'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754323597/amp-darwin-arm64.zip'
      sha256 '81c6a4b9f73575ae157bd1dca9aa7bd7f68a744dfa5ba988f4c78e7cc6dfa587'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754323597/amp-darwin-x64.zip'
      sha256 '0d2aa6fd31f76a226f800a4a07e8e2abae19a61fe349c74b7c1debebe34cdb17'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754323597/amp-linux-arm64'
      sha256 '0018aae78f65b4ca7f376357310160144891bb67efdf5f626effa202c7ef4d56'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754323597/amp-linux-x64'
      sha256 '7a915ab29677fbb2b28870490cd442ef253f228de52a0502ac02b14967f70126'
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
