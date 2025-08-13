# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755086883/amp-darwin-arm64.zip'
  sha256 '1691bf2b1c4be4975264aced4c6fd1efd9f7c8b11d7fdfc5181fc992ae68c619'
  version '0.0.1755086883'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755086883/amp-darwin-arm64.zip'
      sha256 '1691bf2b1c4be4975264aced4c6fd1efd9f7c8b11d7fdfc5181fc992ae68c619'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755086883/amp-darwin-x64.zip'
      sha256 'ec7fab74c885170918ceba368f3ecc05b7ccca339296bd09e8301aab308fbde4'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755086883/amp-linux-arm64'
      sha256 '4f133733674e213d86b2010858cfefcb2dd3e412f24c09835f07c6c00a170be4'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755086883/amp-linux-x64'
      sha256 '12057e8287b264b538d802b473a9474a8060e94ec1150142cd6eedac7bcaff52'
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
