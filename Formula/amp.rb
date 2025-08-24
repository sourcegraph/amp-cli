# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756008541/amp-darwin-arm64.zip'
  sha256 '8d1ea50c3d250efe003d99db62b1d1601374de9e189b598f1f4504b19072a2e6'
  version '0.0.1756008541'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756008541/amp-darwin-arm64.zip'
      sha256 '8d1ea50c3d250efe003d99db62b1d1601374de9e189b598f1f4504b19072a2e6'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756008541/amp-darwin-x64.zip'
      sha256 '5a80d7c36749a60077f6b469f9f5c8c29649cb0ccbd41c3ba036418d53b7e717'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756008541/amp-linux-arm64'
      sha256 '2b12396cf0bcf23915c1ea45c696f18c9f808ba5d64471ba8d6b4ef4e001b734'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756008541/amp-linux-x64'
      sha256 '3df5f4644aaf437f28f52c752c018c48d9dc72ddd2dd9f9b25044d4206636f40'
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
