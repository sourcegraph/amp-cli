# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755936334/amp-darwin-arm64.zip'
  sha256 '10c3fafa43d0391bcb457cb61334fa330492dbcc0428eac2fc9314930ec0bf2f'
  version '0.0.1755936334'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755936334/amp-darwin-arm64.zip'
      sha256 '10c3fafa43d0391bcb457cb61334fa330492dbcc0428eac2fc9314930ec0bf2f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755936334/amp-darwin-x64.zip'
      sha256 '21d9d00b64c55ed15f25d2a99fea1f9b8341fa316f65335aeb00f9bafa4b84b9'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755936334/amp-linux-arm64'
      sha256 '062d2d42780d51b2a36315180628c95236b765e67f078a12fdb5414afd42c0dc'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755936334/amp-linux-x64'
      sha256 'ebd21bf7b1dd9e2768b9d71c2b5a4d5416e2a3ff44ef98b4e78035e8781dad21'
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
