# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754510740/amp-darwin-arm64.zip'
  sha256 'ea434d1dddd85b1629a11f6bea99d822b9f07a3c7a0aac57ba531dac530a562f'
  version '0.0.1754510740'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754510740/amp-darwin-arm64.zip'
      sha256 'ea434d1dddd85b1629a11f6bea99d822b9f07a3c7a0aac57ba531dac530a562f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754510740/amp-darwin-x64.zip'
      sha256 '4a75e9494bbeab8b25ceb9ebb733bf52074d2bc6930ccb18d628070a70a3cd94'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754510740/amp-linux-arm64'
      sha256 '37f1789970f8e37fc5039c469b6e855abdbdb186ff2b7261ba13349cde3c7e53'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754510740/amp-linux-x64'
      sha256 '6c50b093c3925c2abcf82e5f4a161ce51a10128bd5cec5bc0e7fcd455d027948'
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
