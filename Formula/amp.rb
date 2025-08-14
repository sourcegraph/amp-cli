# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755144697/amp-darwin-arm64.zip'
  sha256 'a10027ebd48eb56d4cbda53e2faef32af99fc8a5b574cbdc7db8901c0c0fcaff'
  version '0.0.1755144697'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755144697/amp-darwin-arm64.zip'
      sha256 'a10027ebd48eb56d4cbda53e2faef32af99fc8a5b574cbdc7db8901c0c0fcaff'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755144697/amp-darwin-x64.zip'
      sha256 '703590d1dec0e65fd4d4b58ed81e0534a47094ced9bf2a4b7ac67fe7893cec3f'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755144697/amp-linux-arm64'
      sha256 'd87fcbb339b27f3a6a606ef993419218f0eca095ad98f0bccd995f46c1607ab2'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755144697/amp-linux-x64'
      sha256 '9da362204f3b7424612827bdb8062d59850501a66920494f9d75d19bd2e26af0'
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
