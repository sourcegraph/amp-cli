# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755115501/amp-darwin-arm64.zip'
  sha256 'ab55e3e672475e3841495c174992a2ebf17ab58598f158396897c0d74e3192a9'
  version '0.0.1755115501'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755115501/amp-darwin-arm64.zip'
      sha256 'ab55e3e672475e3841495c174992a2ebf17ab58598f158396897c0d74e3192a9'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755115501/amp-darwin-x64.zip'
      sha256 'bc7a5c1ad6af13e259e7396006b498bd21bde2f45967798d3f889372f5328fed'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755115501/amp-linux-arm64'
      sha256 'bd2d020a6d802f678dc3584653dfd41f28e34a7988dffbf6f09af2ebdeae111c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755115501/amp-linux-x64'
      sha256 '032d402f7d2b42d49d0180486e14112bc27711875cab711e60bba7b2bc2b90a6'
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
