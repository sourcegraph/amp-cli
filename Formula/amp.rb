# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754381202/amp-darwin-arm64.zip'
  sha256 'eccafd14b94364e79ae4e60d386a1f5140d864dda6b180d7b6648d038b684176'
  version '0.0.1754381202'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754381202/amp-darwin-arm64.zip'
      sha256 'eccafd14b94364e79ae4e60d386a1f5140d864dda6b180d7b6648d038b684176'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754381202/amp-darwin-x64.zip'
      sha256 'cd48a763459c92ddede8d14601432d392982ec2b516d7b8799d88d5144cc3f83'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754381202/amp-linux-arm64'
      sha256 '29341fa2106f1d070f089ffa5307abb84579772fc508a26cdb1b4be9c6bbe9e8'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754381202/amp-linux-x64'
      sha256 'a17a926baa2288b2a236751770fdd0607a42e93049a5b094cd205b4bfbe912b1'
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
