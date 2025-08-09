# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754769897/amp-darwin-arm64.zip'
  sha256 'd8fb072e40fd5aa6b24fa5b9da710c694c6d62e28528f3fd282a56ea976e2d27'
  version '0.0.1754769897'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754769897/amp-darwin-arm64.zip'
      sha256 'd8fb072e40fd5aa6b24fa5b9da710c694c6d62e28528f3fd282a56ea976e2d27'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754769897/amp-darwin-x64.zip'
      sha256 '2f53c5b688371f92a43e206358903c2f1cb4adf63dfee2626faa13c8038a4413'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754769897/amp-linux-arm64'
      sha256 'dc2fb78f9aa3f3c4947a65bdd7ad6056549e470cfe243f37089546a2608f75bf'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754769897/amp-linux-x64'
      sha256 'd0ec04359cab4d9a327326d1e63d9eccdab6e4c4ebcd9cdbbf1f0989c20e28cf'
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
