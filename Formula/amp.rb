# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754212808/amp-darwin-arm64.zip'
  sha256 'cd3e751dec9a7081af92f24a91970170d4d9cd1fd362acc2514266a7bd989075'
  version '0.0.1754212808'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754212808/amp-darwin-arm64.zip'
      sha256 'cd3e751dec9a7081af92f24a91970170d4d9cd1fd362acc2514266a7bd989075'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754212808/amp-darwin-x64.zip'
      sha256 'b891555c7edd1ee9fe79a88c961351227856bba5476d267233b2360a00b71ce8'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754212808/amp-linux-arm64'
      sha256 '22257949237a5e8e8aac5dc81b4447828b8330b8f000af2ea20763ccb493faa7'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754212808/amp-linux-x64'
      sha256 '93c73fda08f64512a99cf270d30f480d2a769109f1aa19b9f6d23e62b0a604bf'
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
