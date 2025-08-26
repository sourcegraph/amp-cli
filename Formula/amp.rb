# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756238726/amp-darwin-arm64.zip'
  sha256 '541179d61bc999326443689475812c9d4b1da13c0293d6f1ab5f714aac34b83c'
  version '0.0.1756238726'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756238726/amp-darwin-arm64.zip'
      sha256 '541179d61bc999326443689475812c9d4b1da13c0293d6f1ab5f714aac34b83c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756238726/amp-darwin-x64.zip'
      sha256 'f2eaad4ac4e7119f9706988566d122d457d1b3d5e1c42ddc17ec843d20d13afa'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756238726/amp-linux-arm64'
      sha256 'c7c6c1a4ee2da65be20b1b0a20b896c7897096b94e47fb1e0e9be863cfab6f9f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756238726/amp-linux-x64'
      sha256 '5c907f0e47ac4a5aa3940c9bac23a701c9a2d9aeff2cfa1aeca39cbc72b39edc'
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
