# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754203710/amp-darwin-arm64.zip'
  sha256 'a50a42198fc815a0475f566a16164e69b67633e1896633ee42827ebf8c835ae6'
  version '0.0.1754203710'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754203710/amp-darwin-arm64.zip'
      sha256 'a50a42198fc815a0475f566a16164e69b67633e1896633ee42827ebf8c835ae6'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754203710/amp-darwin-x64.zip'
      sha256 '0595cbeb198236153f09165f2c17f1c03399ca3d2a3b17126565e1919013a956'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754203710/amp-linux-arm64'
      sha256 'b186cca11b14d50f57f3cdf44723a67b3b675da747e7152998bf8fa4a15967df'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754203710/amp-linux-x64'
      sha256 '801b70e083720716e2454e0e3de1b036ccc269fc5535e1248cda83c66444e886'
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
