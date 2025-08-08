# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754654941/amp-darwin-arm64.zip'
  sha256 '42c7ff3d06c45fda0fe932d861d1bd5d84ae1ba694ef37254208a8b4ddb08827'
  version '0.0.1754654941'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754654941/amp-darwin-arm64.zip'
      sha256 '42c7ff3d06c45fda0fe932d861d1bd5d84ae1ba694ef37254208a8b4ddb08827'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754654941/amp-darwin-x64.zip'
      sha256 '7ac49a16113feb3533c9158456c1747524676987259be409ff4e4e9c29001a7c'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754654941/amp-linux-arm64'
      sha256 '8c3246dc13a8dde3cdc6d70890c4a7b47964ac003d9fdce8995a7dd12714365e'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754654941/amp-linux-x64'
      sha256 '8598e69bc7bacf953f4b47e071df529acf307b55b2200b0950ab014b5516e5b6'
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
