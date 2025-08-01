# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/v0.0.1754050083/amp-darwin-arm64'
  sha256 '1d3eae41dcd8476b3eaf2a47627a735ea14816b5304bf0dafc88699d06d93357'
  version '0.0.1754050083'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/v0.0.1754050083/amp-darwin-arm64'
      sha256 '1d3eae41dcd8476b3eaf2a47627a735ea14816b5304bf0dafc88699d06d93357'
    else
      url 'https://packages.ampcode.com/binaries/v0.0.1754050083/amp-darwin-x64'
      sha256 'af846e94968ba7eaa05ee865427c07047a9fbe12c425986e038e9f9c0b3810d9'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/v0.0.1754050083/amp-linux-arm64'
      sha256 '167e5ebaace8e6d57175240cd387c2222d947339f9f74c9855bfc38f8ff109e5'
    else
      url 'https://packages.ampcode.com/binaries/v0.0.1754050083/amp-linux-x64'
      sha256 '31a8bbdcb345bac6fea68c2fdb86f3c874818069335f7fb04812d4e4bf2e6b90'
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
