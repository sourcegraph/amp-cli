# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755476439/amp-darwin-arm64.zip'
  sha256 '571c3d3e7036255afe5d4b9722d0fd07848b3d1963d70ad79d836a17fdb419a9'
  version '0.0.1755476439'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755476439/amp-darwin-arm64.zip'
      sha256 '571c3d3e7036255afe5d4b9722d0fd07848b3d1963d70ad79d836a17fdb419a9'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755476439/amp-darwin-x64.zip'
      sha256 'e783f238b6d640ba13fc33132f3b02767854ebb6c8d76f5972c65ea0dfdafe26'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755476439/amp-linux-arm64'
      sha256 'e8e666e9e38a030892b075f122b7c5357d15a3dc7089816e76f9c471b396c8b2'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755476439/amp-linux-x64'
      sha256 '7d848208aa9e62c7accaeac62801f5de27cb34356aee69b1dcf9b86fad2d523b'
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
