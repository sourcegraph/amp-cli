# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755950795/amp-darwin-arm64.zip'
  sha256 '4dbd214ab6402e18c74d9532a7560396ee7bf7f056842ff2add7e8db7dd5c3c2'
  version '0.0.1755950795'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755950795/amp-darwin-arm64.zip'
      sha256 '4dbd214ab6402e18c74d9532a7560396ee7bf7f056842ff2add7e8db7dd5c3c2'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755950795/amp-darwin-x64.zip'
      sha256 '94e0e60d7faa203febe28c0f310476e2c4bc77ab749868a7a9a7b01eb63052ac'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755950795/amp-linux-arm64'
      sha256 '64af8fa670191f41288599ae0f524f376285c3eb17a56c668dab067cc015ec93'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755950795/amp-linux-x64'
      sha256 '4e08d27963e34fc9b13214b02a601463df171f11a01e816171129765c3abae64'
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
