# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755835518/amp-darwin-arm64.zip'
  sha256 '4cbe34212bbb5a47f6227600c63976b04bb80ecbb98634e889280943a31772d4'
  version '0.0.1755835518'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755835518/amp-darwin-arm64.zip'
      sha256 '4cbe34212bbb5a47f6227600c63976b04bb80ecbb98634e889280943a31772d4'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755835518/amp-darwin-x64.zip'
      sha256 'f0ed3c36df742e498e8477392edb4640606d7c3c09e19caabd807e005cd6ffba'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755835518/amp-linux-arm64'
      sha256 '3243dbdd7d148c26b84b9da384c5df0ee7f7775b72969c02802454d964ec20ab'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755835518/amp-linux-x64'
      sha256 'eb5b66ac014435a259b5626161154191bb098bd853cf55ae1ab46d57f3a4b371'
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
