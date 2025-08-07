# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754554029/amp-darwin-arm64.zip'
  sha256 '42fdc25d1275119c3a6d18f2dd8e25020f2672bd47bcb525030cdd58ed821048'
  version '0.0.1754554029'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754554029/amp-darwin-arm64.zip'
      sha256 '42fdc25d1275119c3a6d18f2dd8e25020f2672bd47bcb525030cdd58ed821048'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754554029/amp-darwin-x64.zip'
      sha256 '69f4bd8cc27b5f29e509e0503735abd3939f3ebbf9d6717c560a60b0eff0a1f4'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754554029/amp-linux-arm64'
      sha256 '4616996569c3421d0f7a8fc1d13a0b18d508a02b748231202b2b2aeed7dd6e1b'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754554029/amp-linux-x64'
      sha256 'dbbbec697abdd98984184149394b097c9a7622c4b0c77387b72d6fac0e13169d'
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
