# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756397154/amp-darwin-arm64.zip'
  sha256 '297a3108456628c3a33ec22b6256bd0b1ccafd31ce82053e0d8657a4da216b8c'
  version '0.0.1756397154'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756397154/amp-darwin-arm64.zip'
      sha256 '297a3108456628c3a33ec22b6256bd0b1ccafd31ce82053e0d8657a4da216b8c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756397154/amp-darwin-x64.zip'
      sha256 'c8ff57979fd38cfea999c5ffb087a5e9459e914bcd1126ec9e86bc65348893a2'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756397154/amp-linux-arm64'
      sha256 'bd46dc926965acb7cc43f3a7cbe7f6c761ba5028ce25f4441d66eaef8fd3faac'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756397154/amp-linux-x64'
      sha256 '407b09c53131dfd1672452ec3368444ef9cd2cadbb32051d2b0b30ca5c6e3a4a'
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
