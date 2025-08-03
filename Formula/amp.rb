# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754231760/amp-darwin-arm64.zip'
  sha256 'aaf4f9a5ccee9845559216de418945a9fb47e0a9ee3415e5c08fb8afdc7302b4'
  version '0.0.1754231760'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754231760/amp-darwin-arm64.zip'
      sha256 'aaf4f9a5ccee9845559216de418945a9fb47e0a9ee3415e5c08fb8afdc7302b4'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754231760/amp-darwin-x64.zip'
      sha256 '418650a0011108d7d1a93aeb60fb687f455b9d230ca466d7a0d45153f2dcd5e0'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754231760/amp-linux-arm64'
      sha256 '594defdd5a8dbaa9400d74e191c1fe03cf4cdb491e3a1f84a9abc230669b30b5'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754231760/amp-linux-x64'
      sha256 'f356ed3b0469c2c0effd2972ccade6a29b34d065f42b20fae219b9b37ea941da'
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
