# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755662726/amp-darwin-arm64.zip'
  sha256 'a02e1b1c41da87808f0380979cb34b91744d656aa7e435bbedc6879879e95ed4'
  version '0.0.1755662726'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755662726/amp-darwin-arm64.zip'
      sha256 'a02e1b1c41da87808f0380979cb34b91744d656aa7e435bbedc6879879e95ed4'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755662726/amp-darwin-x64.zip'
      sha256 'ae5245a9fc64a6e0a747dcd628aba228c5f238894973759dc1c6a22ea54912d8'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755662726/amp-linux-arm64'
      sha256 '7ab3d109d87de16ba9981a876811913d80ce8528270aa24c3c5a464df2dd22f2'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755662726/amp-linux-x64'
      sha256 '63bc4de77c219fcbddc3aea36af779b8fbf4f39b19ddf97724a398bfc8fd5629'
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
