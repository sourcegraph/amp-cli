# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754592014/amp-darwin-arm64.zip'
  sha256 '62ad26cbed80f9a184193fc8ac1a1e92e977b435ea1bb92cdb107e6d2e70a404'
  version '0.0.1754592014'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754592014/amp-darwin-arm64.zip'
      sha256 '62ad26cbed80f9a184193fc8ac1a1e92e977b435ea1bb92cdb107e6d2e70a404'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754592014/amp-darwin-x64.zip'
      sha256 'a8daca5dc8f49d61f7ca650a3f6d5dcf7c67efe71a5edbabfeb463450b16a846'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754592014/amp-linux-arm64'
      sha256 '75a5e3a3db334fb6c4f3f17427539b4176c2ebcefd4ef630faa4159614c9d9d4'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754592014/amp-linux-x64'
      sha256 '6c3e7d19f8eba4b06b114fef65d38aba3a041d5de75dbbd8631eb8671ad2f019'
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
