# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754899627/amp-darwin-arm64.zip'
  sha256 '2d3b784a77f0d94ced4dde6160476ca8a85d0e95e6376c921cd64fbc03bf5a2a'
  version '0.0.1754899627'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754899627/amp-darwin-arm64.zip'
      sha256 '2d3b784a77f0d94ced4dde6160476ca8a85d0e95e6376c921cd64fbc03bf5a2a'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754899627/amp-darwin-x64.zip'
      sha256 '2f3532e7d087d5b53450b09871d81e573fe082b8dce57e885d1c3ba5e0b9a394'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754899627/amp-linux-arm64'
      sha256 '7ec1ed6292c7cede6d148b7d1093e09ed7e58d07cf5015e05bd9f1b87f525c71'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754899627/amp-linux-x64'
      sha256 '239327b9d0d4eff33d9918c07c945657aee4f7aa8357be9447e4506ea52f86bd'
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
