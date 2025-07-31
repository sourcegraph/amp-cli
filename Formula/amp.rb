# frozen_string_literal: true

# Amp CLI - AI-powered coding assistant
class Amp < Formula
  desc 'Amp CLI - AI-powered coding assistant'
  homepage 'https://github.com/sourcegraph/amp-packages'
  url '                https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753987260-gda0d4e/amp-darwin-arm64'
  sha256 'db7a96f9d1a4f34003a85f3970f63c8724fea4b30ea0adfffbc1963c36798709'
  version '0.0.1753987260-gda0d4e'

  on_macos do
    if Hardware::CPU.arm?
      url '                https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753987260-gda0d4e/amp-darwin-arm64'
      sha256 'db7a96f9d1a4f34003a85f3970f63c8724fea4b30ea0adfffbc1963c36798709'
    else
      url '                https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753987260-gda0d4e/amp-darwin-x64'
      sha256 '33f56c581bbfc7bea84b6127dd614f2ef362730635ba2c115ac82a66f348c26b'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url '                https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753987260-gda0d4e/amp-linux-arm64'
      sha256 '075491b8ebf0145dfa8f925ec338c158ec45d82ea105c95325d35964896b44b6'
    else
      url '                https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753987260-gda0d4e/amp-linux-x64'
      sha256 'f5b611c471c5487e9004173aee93f26c777aee351de2a4aceaf1d947be2b7d4a'
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
