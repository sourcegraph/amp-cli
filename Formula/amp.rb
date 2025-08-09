# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754755499/amp-darwin-arm64.zip'
  sha256 '1ecd6bd32821f76fd47e45a717e2e5aeb6776464151f10caf71729e7da325d12'
  version '0.0.1754755499'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754755499/amp-darwin-arm64.zip'
      sha256 '1ecd6bd32821f76fd47e45a717e2e5aeb6776464151f10caf71729e7da325d12'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754755499/amp-darwin-x64.zip'
      sha256 '63ca8a70138418d76b3e9f56fef948f5c67b94975edc1355922d9e67ed5be649'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754755499/amp-linux-arm64'
      sha256 '05824ae1d87ea2574fa4278c32f8cebcc6604d94f12e8447d4194be327155434'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754755499/amp-linux-x64'
      sha256 '72f6c45989d77d31cd0bdbcaec747969e21d7e7414ad400fe81fa95840682a15'
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
