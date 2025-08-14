# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755158796/amp-darwin-arm64.zip'
  sha256 'd2c8e7dd41340ff01c537ec4863d0fe9361e4ad79272d9962aa8c2201c7789d9'
  version '0.0.1755158796'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755158796/amp-darwin-arm64.zip'
      sha256 'd2c8e7dd41340ff01c537ec4863d0fe9361e4ad79272d9962aa8c2201c7789d9'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755158796/amp-darwin-x64.zip'
      sha256 'f56440585642a4268f5194e7d513efe23f2cb75f2d8d2664f265a48dcdc433e8'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755158796/amp-linux-arm64'
      sha256 '69ddd7a860fa7f34ad7a68f1b8897808241cd30f15482ffbc43be586c3185aba'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755158796/amp-linux-x64'
      sha256 '168788b524bbd66bbf504e18f20f69a05b291b85fcd7ff9f3d7c2e6cfa6e1d20'
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
