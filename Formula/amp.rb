# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754540487/amp-darwin-arm64.zip'
  sha256 'ba5297e3f40e6caeafe3e1dfa9c60701de2fcf2a8139a2fc0843da9dd6f02055'
  version '0.0.1754540487'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754540487/amp-darwin-arm64.zip'
      sha256 'ba5297e3f40e6caeafe3e1dfa9c60701de2fcf2a8139a2fc0843da9dd6f02055'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754540487/amp-darwin-x64.zip'
      sha256 'c9fcf3b24946ce1d94b25e6145176346b6cccbc6a4fe489c74a6de2799796392'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754540487/amp-linux-arm64'
      sha256 '7853a811c866f953a5f08f5db98f417887d5b8e239a1c275271c1a7e89274ff7'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754540487/amp-linux-x64'
      sha256 '442ac080f295ea02f3fc28ba39e5d51f9f45b53ac16b188849f9887d49d67298'
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
