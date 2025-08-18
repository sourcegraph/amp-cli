# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755547525/amp-darwin-arm64.zip'
  sha256 '5ab79ab69fc32d3cff9247ff2ef443f56b6f224024071ad979048ff742478789'
  version '0.0.1755547525'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755547525/amp-darwin-arm64.zip'
      sha256 '5ab79ab69fc32d3cff9247ff2ef443f56b6f224024071ad979048ff742478789'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755547525/amp-darwin-x64.zip'
      sha256 '6e39e6edb96d25807b56a0dcda52527f58a8a7a77b4c118d1cd96064cc9e46fc'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755547525/amp-linux-arm64'
      sha256 'c397fc9a587282a0123423648bcc175cb048cae983c3df8d112ff9171ad5e935'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755547525/amp-linux-x64'
      sha256 'fee0ffd17eb5d0366534caceafed027a7adb87096581bea12a12f7c035a5d120'
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
