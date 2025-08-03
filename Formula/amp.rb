# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754206759/amp-darwin-arm64.zip'
  sha256 'aa0ff47af4baedb07838a0b3b3ba5d152697f628912d57c6e2755f1ff1de010c'
  version '0.0.1754206759'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754206759/amp-darwin-arm64.zip'
      sha256 'aa0ff47af4baedb07838a0b3b3ba5d152697f628912d57c6e2755f1ff1de010c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754206759/amp-darwin-x64.zip'
      sha256 '11cf2df3fd5ca762397060ae53b05c44d794f962b2e7b559af96b2b2799f3a44'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754206759/amp-linux-arm64'
      sha256 '4166a07d9eed33da554712c7aae3734e5a8c663937007858f230189e450aef1b'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754206759/amp-linux-x64'
      sha256 '4e8aaee9db09de8a18499e514fe77574664a2b90fd5fa5fe80808f8a41dc0c35'
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
