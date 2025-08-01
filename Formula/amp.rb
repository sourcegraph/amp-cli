# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://github.com/sourcegraph/amp-cli'
  url 'https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754035600/amp-darwin-arm64'
  sha256 'c98dc23b96f8abfd10a9c30e91cf4e2128ed00f4f1419f80109598b873f17e31'
  version '0.0.1754035600'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754035600/amp-darwin-arm64'
      sha256 'c98dc23b96f8abfd10a9c30e91cf4e2128ed00f4f1419f80109598b873f17e31'
    else
      url 'https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754035600/amp-darwin-x64'
      sha256 'dbe57d76d6c19322fbfe506af6d207577d98af41f5824161aeb8b4a3465de33b'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754035600/amp-linux-arm64'
      sha256 '6bb51ffb56e7aa078932f65d4e9b419102c726caf098ffc1aa924af7595e36bd'
    else
      url 'https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754035600/amp-linux-x64'
      sha256 '953bd1991e6baddd5025ad8c0c985d350dc808cc0c586c589d313e8302b43868'
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
