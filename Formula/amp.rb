# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755044360/amp-darwin-arm64.zip'
  sha256 '278ed600678d4b3c874aa3c5ced1cfd72ada558bfb85add1397ecddc90f722c7'
  version '0.0.1755044360'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755044360/amp-darwin-arm64.zip'
      sha256 '278ed600678d4b3c874aa3c5ced1cfd72ada558bfb85add1397ecddc90f722c7'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755044360/amp-darwin-x64.zip'
      sha256 '745625426082d0d256273fe28ac064bc436a1892b3291391c1fea9df956f7a49'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755044360/amp-linux-arm64'
      sha256 '737c99b798d8181b2abe7b81a4ce2c1d718ec4fc59ac51c9332663574535c083'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755044360/amp-linux-x64'
      sha256 '9a1b3eacdd12ebc471b01ccd33ff29e189c862a21b8385e904fc44d8efa7515b'
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
