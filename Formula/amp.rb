# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754683500/amp-darwin-arm64.zip'
  sha256 'a4e878e626348e82031785cfeb2dbde662f7d00b8f574326a11d22d6289be427'
  version '0.0.1754683500'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754683500/amp-darwin-arm64.zip'
      sha256 'a4e878e626348e82031785cfeb2dbde662f7d00b8f574326a11d22d6289be427'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754683500/amp-darwin-x64.zip'
      sha256 '9db5c26ea569e2f388ea5eae5bd1b681bbec84561dd0786fd1e2dec207ee88a7'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754683500/amp-linux-arm64'
      sha256 'a82bff5d74d12470ab9bcb89447333faf86ac7cb23fdceaa1715a3bbe86ea52f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754683500/amp-linux-x64'
      sha256 'b8d26c0dcdfc1c38e6e142564759601665175fc81e69ca844dc7e1310e80d15d'
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
