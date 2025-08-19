# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755619544/amp-darwin-arm64.zip'
  sha256 'f025d36dcf44e83a469d1ecc9165302fcca06672479891a84a8273f632848fb3'
  version '0.0.1755619544'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755619544/amp-darwin-arm64.zip'
      sha256 'f025d36dcf44e83a469d1ecc9165302fcca06672479891a84a8273f632848fb3'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755619544/amp-darwin-x64.zip'
      sha256 'f340cd8ef78cd872034521dda825285df8ba6bf69306f11c07dcb0f19476836b'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755619544/amp-linux-arm64'
      sha256 'd37d390c57081872a938e14740c8f416f4d2fc9690fa181016e667eb2238cd8f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755619544/amp-linux-x64'
      sha256 '1cc7795bf06d540cc9b3e4fc8e5dab63de2d9869e2be0005bb969b10d87f72d0'
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
