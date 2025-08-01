# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://github.com/sourcegraph/amp-cli'
  url 'https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754018651/amp-darwin-arm64'
  sha256 '3f7a613bfcd164a366dadd59d86d9a44c6f7fd68e447200ea690a4840af8fa38'
  version '0.0.1754018651'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754018651/amp-darwin-arm64'
      sha256 '3f7a613bfcd164a366dadd59d86d9a44c6f7fd68e447200ea690a4840af8fa38'
    else
      url 'https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754018651/amp-darwin-x64'
      sha256 'd526ec1a8bc6827f9163f7bedfbcb85ea31d3a799ffe7e31eb9d2fe9e51e1bd5'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754018651/amp-linux-arm64'
      sha256 '95343e210c400ee287c92e71f93a0ab210849f0c3ab888ff7ce312d7cc112abf'
    else
      url 'https://github.com/sourcegraph/amp-cli/releases/download/v0.0.1754018651/amp-linux-x64'
      sha256 'db119c8f0953f27f4167256ea8fb829c1801ef5892486d16b2e85b70953420d4'
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
