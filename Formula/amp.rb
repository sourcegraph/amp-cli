# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754856315/amp-darwin-arm64.zip'
  sha256 '643394180c1b3b9eeb4dff0589bee129e386547095942ccd3c079b350206b903'
  version '0.0.1754856315'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754856315/amp-darwin-arm64.zip'
      sha256 '643394180c1b3b9eeb4dff0589bee129e386547095942ccd3c079b350206b903'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754856315/amp-darwin-x64.zip'
      sha256 '8f23f22000dc62279a99c2a27e76b68714364c74be5b28d97dfdfdab7d570fc0'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754856315/amp-linux-arm64'
      sha256 'f8c3dc68498c185da96e8a9eab6f3ae35549e0b524bcd32f11da7754230ad9c3'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754856315/amp-linux-x64'
      sha256 '82db799395879f54fbc76bff1261520336d2c452e3c1c5983e0dfe4d320df338'
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
