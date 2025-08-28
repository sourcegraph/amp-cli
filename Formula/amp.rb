# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1756368384/amp-darwin-arm64.zip'
  sha256 'cebc6afb1d5474b1645c382ec9da167e29b9bd1908300fb081a52441144db5d6'
  version '0.0.1756368384'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756368384/amp-darwin-arm64.zip'
      sha256 'cebc6afb1d5474b1645c382ec9da167e29b9bd1908300fb081a52441144db5d6'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756368384/amp-darwin-x64.zip'
      sha256 '71afa2c15b05ce58efc41ce9d7c22d8b215c6916e359a4982e54493751b9673a'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756368384/amp-linux-arm64'
      sha256 '1b1d6699c891f53efbc75aecb355d17dbfcd42717e7a3773318af384f4ccb074'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1756368384/amp-linux-x64'
      sha256 'f7432de555be797aace880365a75a1bf6a69ad14dc7ca0a3cac60cbe28ba85e9'
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
