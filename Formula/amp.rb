# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754669147/amp-darwin-arm64.zip'
  sha256 'd47ee17be8d6513ac75cc648b29604f80a4afd9b90d983846b7df49148d93a4a'
  version '0.0.1754669147'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754669147/amp-darwin-arm64.zip'
      sha256 'd47ee17be8d6513ac75cc648b29604f80a4afd9b90d983846b7df49148d93a4a'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754669147/amp-darwin-x64.zip'
      sha256 'd9711d28688d9b5203babaa772f9dc0c3af0d6c0fafa577c93545e35d03be69a'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754669147/amp-linux-arm64'
      sha256 '25e99f6170507490ac9c2fe36f60d001098ae2f3fa890cedc95aec3bb19caf68'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754669147/amp-linux-x64'
      sha256 '965e352658167a570a980be0174dc208270723ed86c847f6af8bf73540fc0c05'
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
