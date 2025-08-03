# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754205373/amp-darwin-arm64.zip'
  sha256 'bf1babd175106908e4843afa79dcc8077d509febde695fdb21200d4bc9a60453'
  version '0.0.1754205373'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754205373/amp-darwin-arm64.zip'
      sha256 'bf1babd175106908e4843afa79dcc8077d509febde695fdb21200d4bc9a60453'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754205373/amp-darwin-x64.zip'
      sha256 '6cecadda9d2c10217860374e8378540c6afde64d60e181b027efe682ec6a076c'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754205373/amp-linux-arm64'
      sha256 '32a34c6a53fe917cfd5843e0498522e54e370f7b1943131720b437538c7db21e'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754205373/amp-linux-x64'
      sha256 'f7f9944749d974b877debedb3a0ac6c00b79479391d6a63c9df3d07ecf496b8e'
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
