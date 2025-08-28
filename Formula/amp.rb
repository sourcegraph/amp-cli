# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756411524/amp-darwin-arm64.zip'
  sha256 '277bd00b50b4fd1303ef8c5a45860d662b474c9fbf1e4eb9fbdda67fcae2f081'
  version '0.0.1756411524'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756411524/amp-darwin-arm64.zip'
      sha256 '277bd00b50b4fd1303ef8c5a45860d662b474c9fbf1e4eb9fbdda67fcae2f081'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756411524/amp-darwin-x64.zip'
      sha256 '783b97e293ee9243ac2ba10d8217c68ca7a1171dd9a4fa49e7bbe98004f80139'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756411524/amp-linux-arm64'
      sha256 'c67d9428e466ba9338862f4ece6e9a79622cfe4633d2e15a31c1b3090698aa58'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756411524/amp-linux-x64'
      sha256 '6011641cc80128718b85fd4f43f331d2e8483c551462679adfc1109844262428'
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
