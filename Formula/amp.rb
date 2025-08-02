# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754150699/amp-darwin-arm64.zip'
  sha256 '7e98232bf4d8d11ea08997cdc37cd0daa75341af97e7a55473e45114920a53e6'
  version '0.0.1754150699'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754150699/amp-darwin-arm64.zip'
      sha256 '7e98232bf4d8d11ea08997cdc37cd0daa75341af97e7a55473e45114920a53e6'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754150699/amp-darwin-x64.zip'
      sha256 '6d9357eae43ecc54c0df21c608292827ab9a9559f549013b50e0b4189b671d9e'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754150699/amp-linux-arm64'
      sha256 '144612f3b07c66deca2d13f38e15500e1b79e69454284ca73e3d68e762ce19aa'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754150699/amp-linux-x64'
      sha256 '5c3568b37a025c36bfe6c111b870609bf3c7470b2a64db3c6f4f73db255d1f09'
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
