# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754914095/amp-darwin-arm64.zip'
  sha256 '74ec240235b9f0c7d45ff2292c4ba24c834e3afa6f096f7d286637f6ef45878c'
  version '0.0.1754914095'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754914095/amp-darwin-arm64.zip'
      sha256 '74ec240235b9f0c7d45ff2292c4ba24c834e3afa6f096f7d286637f6ef45878c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754914095/amp-darwin-x64.zip'
      sha256 'aeb41b6afab9638702f899b5fcd10cfcb35ae5c090ac5475a33234a7f74c3198'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754914095/amp-linux-arm64'
      sha256 '7fddea14647bb6107883f6546c1f73af62c0a58c258255b10afcf75020bd786a'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754914095/amp-linux-x64'
      sha256 'ceb7e04156a5dcb2a478a72e56ea5a103785cfcf318af023185f8119c7b09f9b'
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
