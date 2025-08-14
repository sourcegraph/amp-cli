# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755173314/amp-darwin-arm64.zip'
  sha256 '360cfe9cf5447c65816011544f3b5b62f1239df7b1a8665a388e492176ce42cc'
  version '0.0.1755173314'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755173314/amp-darwin-arm64.zip'
      sha256 '360cfe9cf5447c65816011544f3b5b62f1239df7b1a8665a388e492176ce42cc'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755173314/amp-darwin-x64.zip'
      sha256 '335505e3759b9feeb94fdc33837fa7e353e9ce1e7dbdc1325c2b9299990805fe'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755173314/amp-linux-arm64'
      sha256 '6dd4b5997d84f040a11ea843e2fce10a6eb81828babc492d3b9572a0804a4ee5'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755173314/amp-linux-x64'
      sha256 'eb1dcede676716048ed2388fb17d35829bd7f2f4faf9327853905cb4eef90904'
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
