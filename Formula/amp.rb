# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754626856/amp-darwin-arm64.zip'
  sha256 '94f85a49ec5bd7db13ab667da9b528b8df72b12715d1ad2537385499c51b908b'
  version '0.0.1754626856'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754626856/amp-darwin-arm64.zip'
      sha256 '94f85a49ec5bd7db13ab667da9b528b8df72b12715d1ad2537385499c51b908b'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754626856/amp-darwin-x64.zip'
      sha256 '717908ad267c8134dbb1a874c78f6edc8110c3ae6c60d30cf1f0dea96141e169'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754626856/amp-linux-arm64'
      sha256 '52fd3db34b520ca3bec0be789029cca640120e1697c59f711be6d7257708a58c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754626856/amp-linux-x64'
      sha256 '1d6da36b1fd2454176220f12d8da3dca53483e5e1427d114abcb7390a5ac5d47'
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
