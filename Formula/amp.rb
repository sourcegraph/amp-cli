# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755735435/amp-darwin-arm64.zip'
  sha256 '45a2a852844e19451696df4731324aedbe48f41210dd9609618b790233e04589'
  version '0.0.1755735435'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755735435/amp-darwin-arm64.zip'
      sha256 '45a2a852844e19451696df4731324aedbe48f41210dd9609618b790233e04589'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755735435/amp-darwin-x64.zip'
      sha256 '0b0124f9fda221ea28885452591269d0057701b878c8b74bf422cae7810240e3'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755735435/amp-linux-arm64'
      sha256 'c561c999cdeafe22f9827c180621f778e3686b98ebce79723ab4f3ae2b031fe3'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755735435/amp-linux-x64'
      sha256 'aac1f53affb2ad115b42d9601503f8404ac6ab9e50ef6a7ef1a9f39aa93e2c75'
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
