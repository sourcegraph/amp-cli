# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755605277/amp-darwin-arm64.zip'
  sha256 'e5179d015aa90b2d6e31f8ae7687a41b6169456731b2a8589a944f25a7d852f2'
  version '0.0.1755605277'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755605277/amp-darwin-arm64.zip'
      sha256 'e5179d015aa90b2d6e31f8ae7687a41b6169456731b2a8589a944f25a7d852f2'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755605277/amp-darwin-x64.zip'
      sha256 '1640dca7d8bb990fdb5af1eb5fedbbcff154b877798ae46df8579baf7cab5b48'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755605277/amp-linux-arm64'
      sha256 '1ab634202ccf623f2b077de04fdf0ff4fc92c3d580e9ff0cf1e4feee880c4304'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755605277/amp-linux-x64'
      sha256 '2db5ce8be016f87dcb86f02bab0ef272f927589db2e62d8c971aa181e70f0914'
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
