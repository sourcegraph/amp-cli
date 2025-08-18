# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755522323/amp-darwin-arm64.zip'
  sha256 '89d12fc106b04f3679ae633069f41708f6be244e6d801a1c798b60f8d211831f'
  version '0.0.1755522323'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755522323/amp-darwin-arm64.zip'
      sha256 '89d12fc106b04f3679ae633069f41708f6be244e6d801a1c798b60f8d211831f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755522323/amp-darwin-x64.zip'
      sha256 'a0e02105252072e849d43c8e930b600ceb806800a9a638ceff71324920fc8a6d'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755522323/amp-linux-arm64'
      sha256 '13153602e35705d9cf608b1174b613d5edf2b60ca118d645f8af9f9d4fefaf27'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755522323/amp-linux-x64'
      sha256 '0f13476d381008d2e7eb896bd1d85dc8387b1f77f55228be837aed63ae1326e1'
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
