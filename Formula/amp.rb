# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755390045/amp-darwin-arm64.zip'
  sha256 '25efb759e9812e92720fc645f208d571762776336860b3bd8d76957b027e455d'
  version '0.0.1755390045'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755390045/amp-darwin-arm64.zip'
      sha256 '25efb759e9812e92720fc645f208d571762776336860b3bd8d76957b027e455d'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755390045/amp-darwin-x64.zip'
      sha256 '49a73b284daadd6f6201ab0150e669cb29eb63fb7ee5ff3f9532c094a3ec55cf'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755390045/amp-linux-arm64'
      sha256 '2f9dc9bedd85a0bf090322b60ed1fd39c0a665c759517a2169c13db7b58ac0f3'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755390045/amp-linux-x64'
      sha256 'b295f8c51777afc15cf98559172a471feb506468a429daa5224dc6d5e8b337b4'
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
