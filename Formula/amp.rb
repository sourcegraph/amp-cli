# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754591428/amp-darwin-arm64.zip'
  sha256 '8b5886139e410ec103beecf16615ef5498f1af94f07ca2e1b6a15013f34e1a6c'
  version '0.0.1754591428'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754591428/amp-darwin-arm64.zip'
      sha256 '8b5886139e410ec103beecf16615ef5498f1af94f07ca2e1b6a15013f34e1a6c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754591428/amp-darwin-x64.zip'
      sha256 '0dbd4e39db7ab3ab6052c4da26eae1c915a4ae96e82b14287f270ccbac8fc578'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754591428/amp-linux-arm64'
      sha256 'f0fd8d45ec049266e7af6fe4071619ca5facf7f49735dd58a83a2c865f64c4dd'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754591428/amp-linux-x64'
      sha256 'e289b536ba26330a5b4de270611e672f305962e1c3159d5e578ff6b435333979'
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
