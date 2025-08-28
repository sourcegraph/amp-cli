# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756382858/amp-darwin-arm64.zip'
  sha256 '507157548c0b8ef68d72ca5d627f305c551dc171fa1464b8bc135a23a09b4996'
  version '0.0.1756382858'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756382858/amp-darwin-arm64.zip'
      sha256 '507157548c0b8ef68d72ca5d627f305c551dc171fa1464b8bc135a23a09b4996'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756382858/amp-darwin-x64.zip'
      sha256 '7ff0177d371d5835a5f3a12c45fda4e79bc5aab2c82bb5bddbdcca0ad06c2bf8'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756382858/amp-linux-arm64'
      sha256 '4f17203380802d5a62f20dc406a168a5d5f3ef99808579613ee3320725432a63'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756382858/amp-linux-x64'
      sha256 'c076e6664b9a7d34f5b98d0833e79c804751d6b78c1b7b2f5086e296a5c12d89'
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
