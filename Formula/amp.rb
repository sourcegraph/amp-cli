# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755374705/amp-darwin-arm64.zip'
  sha256 '1c0f6a4a100fdaf123630dcb4c1fa113a42e51b7ba6b2ce74dbc5c2d0f9af817'
  version '0.0.1755374705'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755374705/amp-darwin-arm64.zip'
      sha256 '1c0f6a4a100fdaf123630dcb4c1fa113a42e51b7ba6b2ce74dbc5c2d0f9af817'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755374705/amp-darwin-x64.zip'
      sha256 '163a30f903dd87421b33246eb5f7d974bff67636617074cea206660423279929'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755374705/amp-linux-arm64'
      sha256 'fb6e4a9f11cf04f6a3b4284aab551fcf1e3c3b38de84de3b2e06236e22bfafa7'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755374705/amp-linux-x64'
      sha256 'c932a330d63f8caa5dde6154db42d517359831fe2133dd9e054fa9d0e9d04c66'
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
