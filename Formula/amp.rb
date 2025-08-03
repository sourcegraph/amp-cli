# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754207985/amp-darwin-arm64.zip'
  sha256 '6534be779ee75eaf535b116c036d3dadbb3a0968b10539905ff7faae82874eed'
  version '0.0.1754207985'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754207985/amp-darwin-arm64.zip'
      sha256 '6534be779ee75eaf535b116c036d3dadbb3a0968b10539905ff7faae82874eed'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754207985/amp-darwin-x64.zip'
      sha256 'acc6bfbb3bec6076efdbf5bc388ca78a8850a6bfa17544c2a276cb0f0dda654e'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754207985/amp-linux-arm64'
      sha256 'a403801e7ae1bbcf3e911df56376a80dfd56b560dc4efb9a673f0478358f2d86'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754207985/amp-linux-x64'
      sha256 '5f1ed474cb1e1c97e3f24bf296517a30cf942b7dd5a92bf03133b2d118fa5263'
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
