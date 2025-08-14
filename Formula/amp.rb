# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755201924/amp-darwin-arm64.zip'
  sha256 'c1670294f3432ddf2842f83d761c1c13eb7108aa3857194cef4f3bf28155ea85'
  version '0.0.1755201924'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755201924/amp-darwin-arm64.zip'
      sha256 'c1670294f3432ddf2842f83d761c1c13eb7108aa3857194cef4f3bf28155ea85'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755201924/amp-darwin-x64.zip'
      sha256 'f85687543aefb34422c9f949672519c93ca8cd0d01d0ae71e27c2dcae65202f5'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755201924/amp-linux-arm64'
      sha256 '16f6b9edf28c69b4eeacb86bc498fd62fb91e375d428c336c5eb25ac71bd52b4'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755201924/amp-linux-x64'
      sha256 '8d97ac6390ac998321e8e19d97680e9740bb29d398af5bcdeabe91aa71bffeec'
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
