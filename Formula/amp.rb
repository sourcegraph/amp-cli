# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754209281/amp-darwin-arm64.zip'
  sha256 'c76f3779fa28fe9855fc72a0010553ec85fd6a97d642713b4b075bd764ae0767'
  version '0.0.1754209281'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754209281/amp-darwin-arm64.zip'
      sha256 'c76f3779fa28fe9855fc72a0010553ec85fd6a97d642713b4b075bd764ae0767'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754209281/amp-darwin-x64.zip'
      sha256 '5b77c4a2d6c17c7ba0b5558a222f04756c28282b818720e11ac9cc2253ca1ebe'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754209281/amp-linux-arm64'
      sha256 'b5fc003e15bbda6f1063fb6ca9ea10c58302b9dde6139a14b459b74aca3749f6'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754209281/amp-linux-x64'
      sha256 '9297f2d8e6fe7133c39a72f0d7a289650ae584c01994ca1af97e74e159ae7415'
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
