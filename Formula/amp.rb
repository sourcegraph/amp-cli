# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755346018/amp-darwin-arm64.zip'
  sha256 'd12e6a43eb23d6b3b439a31e175c819aec91979ecc1f225a298b86003486dbd9'
  version '0.0.1755346018'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755346018/amp-darwin-arm64.zip'
      sha256 'd12e6a43eb23d6b3b439a31e175c819aec91979ecc1f225a298b86003486dbd9'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755346018/amp-darwin-x64.zip'
      sha256 'e7a3195e5296fd0f0dbd04aa2926e467047f81ec3f094260c1a60de925657be9'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755346018/amp-linux-arm64'
      sha256 '22a2b0eb6f373fcd16cc7ddc96cec84b567bf0df58c64c649659a99b77d2acc8'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755346018/amp-linux-x64'
      sha256 '4a0a95010dbd8cea6dd7edadd0f6dbfcd4c4f64560df647429a5316036d9e1a4'
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
