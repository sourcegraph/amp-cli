# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754210023/amp-darwin-arm64.zip'
  sha256 'a53f90675c2bb1c358f38126196a15a6462e11c09bbbec317cd002cb9294ef85'
  version '0.0.1754210023'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754210023/amp-darwin-arm64.zip'
      sha256 'a53f90675c2bb1c358f38126196a15a6462e11c09bbbec317cd002cb9294ef85'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754210023/amp-darwin-x64.zip'
      sha256 'c061ec0cf96c29db15ec2e7fb286cecd7e36f0334845ced5670f91bc782fc5b6'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754210023/amp-linux-arm64'
      sha256 'c76bace5bdfbf56bdec48b95ce73e47a6ecbab0126b3569e96e38d1c70d583a6'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754210023/amp-linux-x64'
      sha256 'c0a7986248b590588f8c438713de12e31dd8db105762f3b86ac074edb6016a6b'
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
