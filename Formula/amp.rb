# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754526035/amp-darwin-arm64.zip'
  sha256 'b0da837aaf6babde8ec10305d48f306321ee411433739f3264e2cbd250ed21c9'
  version '0.0.1754526035'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754526035/amp-darwin-arm64.zip'
      sha256 'b0da837aaf6babde8ec10305d48f306321ee411433739f3264e2cbd250ed21c9'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754526035/amp-darwin-x64.zip'
      sha256 '9201441021756b6ffb80b3c72fbc66b42cb47201be8b363286941a1531a68726'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754526035/amp-linux-arm64'
      sha256 'ed2880fe8f825508d29a38dcf0e5e62932bd99977722582032668ce645917d81'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754526035/amp-linux-x64'
      sha256 'bcf36ee080a0e50bbd7b3f371092da9e49249d9c5a85af5c48dc341d584807ee'
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
