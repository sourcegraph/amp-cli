# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756340292/amp-darwin-arm64.zip'
  sha256 '6140e961528a90772da5073ce2451c3b0e5d9a8b35e4350767a11b7c6ff145a2'
  version '0.0.1756340292'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756340292/amp-darwin-arm64.zip'
      sha256 '6140e961528a90772da5073ce2451c3b0e5d9a8b35e4350767a11b7c6ff145a2'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756340292/amp-darwin-x64.zip'
      sha256 '776bf64aa5c830f6deb1ad2867dd96e5c91a47eb8ef8ea9be708adae6c049285'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756340292/amp-linux-arm64'
      sha256 '1f7e4cbca5babfa4c9aced1c910bf06285384f7713c4358907215bb95bbb24ab'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756340292/amp-linux-x64'
      sha256 'cfee810e32619848e7b152d215c713887de7c6d2ca419227465dd91de27f8f52'
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
