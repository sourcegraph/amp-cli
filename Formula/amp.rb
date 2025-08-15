# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755217193/amp-darwin-arm64.zip'
  sha256 'fbf668db3f499cd23de7f26e368b6fcd46dc5390ea9f748fe1372be1ed22e042'
  version '0.0.1755217193'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755217193/amp-darwin-arm64.zip'
      sha256 'fbf668db3f499cd23de7f26e368b6fcd46dc5390ea9f748fe1372be1ed22e042'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755217193/amp-darwin-x64.zip'
      sha256 '86db34905132bf1822b53df124b4ce088d6ffeb86a0d5025561d17a78e5806ae'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755217193/amp-linux-arm64'
      sha256 '94efa8c8d885d5d9a3d11a5f4656a45e3db766bdcee04eb7addf68f9ba61983d'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755217193/amp-linux-x64'
      sha256 'cb168d863a4067d244e65b61b1641f0a14f05d61d3395664f798dfe7cf4b3850'
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
