# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755273921/amp-darwin-arm64.zip'
  sha256 'd7fac41351fa868de875d70d7dc6451190cd1a878037a66db2c8fa4ee80ac862'
  version '0.0.1755273921'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755273921/amp-darwin-arm64.zip'
      sha256 'd7fac41351fa868de875d70d7dc6451190cd1a878037a66db2c8fa4ee80ac862'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755273921/amp-darwin-x64.zip'
      sha256 '42115ec7beebd8211196d2963f7f26692dca17b0c33dd828dea40b9cc3ebb096'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755273921/amp-linux-arm64'
      sha256 '0fc2cb1733154986459ec2c7fa4883181581a2a2b71b8bfe8084c6d3a6161c3e'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755273921/amp-linux-x64'
      sha256 'd0654a56c9f98089ee00fee24f1995947f44dd3afab1a15caffef0f8c7ff65db'
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
