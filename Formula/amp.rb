# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754294857/amp-darwin-arm64.zip'
  sha256 '78bebd2072a752093aa1da93bbf669d571f561c652bf2188baa8e3928b7e7401'
  version '0.0.1754294857'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754294857/amp-darwin-arm64.zip'
      sha256 '78bebd2072a752093aa1da93bbf669d571f561c652bf2188baa8e3928b7e7401'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754294857/amp-darwin-x64.zip'
      sha256 'bbf1e7f75158c59b5edbc38903db36260600d2adb218cbef17272f71787c9da9'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754294857/amp-linux-arm64'
      sha256 'b6e9e484522e3fc9f4c49e2a1aa6574cef000f726c05d792fd9c319da8697b6c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754294857/amp-linux-x64'
      sha256 '618c087fd5607b00a347564c1dc1723296ebde60a10efc6b64550b43457c2ed4'
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
