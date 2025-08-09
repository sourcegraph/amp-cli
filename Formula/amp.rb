# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754712655/amp-darwin-arm64.zip'
  sha256 '629c46e219b390f3fbf981eaf637d43647fbd06149759899061994866aabfb10'
  version '0.0.1754712655'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754712655/amp-darwin-arm64.zip'
      sha256 '629c46e219b390f3fbf981eaf637d43647fbd06149759899061994866aabfb10'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754712655/amp-darwin-x64.zip'
      sha256 '85b156179bfed85d517c0821b1154b8be3946a4c7dcdc6a5d90cb3264d1f8810'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754712655/amp-linux-arm64'
      sha256 '97b890911c181d87382ce81c9e224a109a96e51f7013e3f84de1256eadb1c63a'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754712655/amp-linux-x64'
      sha256 '90666d45f989caef1ec758759ce0cad0c70da0edaefe200e0a6c4460845f6eb3'
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
