# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754698714/amp-darwin-arm64.zip'
  sha256 '4b8fc828aec5afdf424c27df87ac5ea2d22a9cb507c159206ecdfb720b2c5122'
  version '0.0.1754698714'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754698714/amp-darwin-arm64.zip'
      sha256 '4b8fc828aec5afdf424c27df87ac5ea2d22a9cb507c159206ecdfb720b2c5122'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754698714/amp-darwin-x64.zip'
      sha256 '2a97fe3b9113904a4115fe2cd54f5b6da81a2e83d4394f2af8306d0be42daf30'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754698714/amp-linux-arm64'
      sha256 '24ec6ea9b89c47edb0dfb0a8261363ba2d1cda4dda487c665bae5ebf30f1900a'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754698714/amp-linux-x64'
      sha256 'f36718c6bc0d7239c834cb6b2ffc0cd8af458c979f7086bb0953385a9141b67d'
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
