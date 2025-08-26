# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756224335/amp-darwin-arm64.zip'
  sha256 '27dfdaddd14a749f05a94a8642d6e1f26eefe935c16d92a29462a24f93bfe53a'
  version '0.0.1756224335'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756224335/amp-darwin-arm64.zip'
      sha256 '27dfdaddd14a749f05a94a8642d6e1f26eefe935c16d92a29462a24f93bfe53a'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756224335/amp-darwin-x64.zip'
      sha256 '212bee3fed3e2e5e4494f9e804a545192be6b47be1d4a3d1fc6f501d0354df31'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756224335/amp-linux-arm64'
      sha256 'd4e8e6a9de92f8ead4f244a429a395beb83da05026ca0511f8ba4f8ccca4846e'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756224335/amp-linux-x64'
      sha256 'a7126a9e7bf4a9099a0d31d1d5ea9760b11910f6cd19f2d2488616b502f239b0'
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
