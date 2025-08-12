# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754971819/amp-darwin-arm64.zip'
  sha256 '83e5efa5911e68697c0123bbaba7273eafae123fca61decf58084eab30272232'
  version '0.0.1754971819'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754971819/amp-darwin-arm64.zip'
      sha256 '83e5efa5911e68697c0123bbaba7273eafae123fca61decf58084eab30272232'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754971819/amp-darwin-x64.zip'
      sha256 '223ecf3d659add26cdd29056ee4580c68c5df626d685f3d085a6222333115545'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754971819/amp-linux-arm64'
      sha256 'cd0d62d508ee083dcd8ce8a2587e8dd754b8f6a2e2da2e6d5242ee8cbe962240'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754971819/amp-linux-x64'
      sha256 '8a23e2b88d50a990d4e849fd375a3ae5bde39bb30ffc5b8281fd9d1483918269'
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
