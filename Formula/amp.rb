# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755677202/amp-darwin-arm64.zip'
  sha256 '1ee95beda4acbfe74ada615664f2e2cc628f1946a5700548541c8b1f238507fc'
  version '0.0.1755677202'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755677202/amp-darwin-arm64.zip'
      sha256 '1ee95beda4acbfe74ada615664f2e2cc628f1946a5700548541c8b1f238507fc'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755677202/amp-darwin-x64.zip'
      sha256 '5e1dacdf6db561800cfdfe2070a4afa28a0f3aca892e9cc9046603afe7831594'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755677202/amp-linux-arm64'
      sha256 '2130c0924142312b1b0590736af231d147e1633db7197b3a106d2d49405d6db0'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755677202/amp-linux-x64'
      sha256 '27858c5aaa47e06543739075275a965478ce0baea10101dbaf8c1f6f0de3536a'
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
