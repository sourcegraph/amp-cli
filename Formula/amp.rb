# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755317263/amp-darwin-arm64.zip'
  sha256 'ecf6660c7afbe65331cf70fab6e5dd328f51fa4535ea4991eb9410786a99c9a9'
  version '0.0.1755317263'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755317263/amp-darwin-arm64.zip'
      sha256 'ecf6660c7afbe65331cf70fab6e5dd328f51fa4535ea4991eb9410786a99c9a9'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755317263/amp-darwin-x64.zip'
      sha256 'b99f7948113b176fa982773421660175f5bc8bf9bd8cccd3a7873f64ede30d3f'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755317263/amp-linux-arm64'
      sha256 'c73794eebd328db0d50504f59d2bd737198e2bdca05a74834c02373a26179373'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755317263/amp-linux-x64'
      sha256 'beb7f5612265fd0be31ca8e246d72bbded950c2678b0139377d545b3c9db6aff'
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
