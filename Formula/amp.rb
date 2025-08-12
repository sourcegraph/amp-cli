# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754986061/amp-darwin-arm64.zip'
  sha256 '6dc828d5c75b02ea4ba884f8899221d4774d47dcb1ecd11a47d277153d19752b'
  version '0.0.1754986061'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754986061/amp-darwin-arm64.zip'
      sha256 '6dc828d5c75b02ea4ba884f8899221d4774d47dcb1ecd11a47d277153d19752b'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754986061/amp-darwin-x64.zip'
      sha256 '7aee2c4b34428da633bbf92de1072efc1fa3d3e6f07a3f70ff3631a59017b580'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754986061/amp-linux-arm64'
      sha256 '9b4158a3ad2bf0093a9bb5fc53e02ffa72cdeff46f56e3fdf9beb0151e4bfd02'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754986061/amp-linux-x64'
      sha256 '85b8e1f0c43514c855d814106e51fe9bff96cbebed39d5e3545da61e5514e700'
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
