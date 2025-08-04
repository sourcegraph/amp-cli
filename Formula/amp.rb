# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754337940/amp-darwin-arm64.zip'
  sha256 '4e9f02fb219c001b21461a8dac83a10bdafc7369d25cd1e97fd08ec9e718ace7'
  version '0.0.1754337940'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754337940/amp-darwin-arm64.zip'
      sha256 '4e9f02fb219c001b21461a8dac83a10bdafc7369d25cd1e97fd08ec9e718ace7'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754337940/amp-darwin-x64.zip'
      sha256 '670e017ca59c5b0c474dc68fff86e864d1420c3fa6127a95aa0c9405b86a88a9'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754337940/amp-linux-arm64'
      sha256 '297bf01b658c83cd56112bf827323bc7a1bfc76bdb8e2e7b60474464973edb2f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754337940/amp-linux-x64'
      sha256 '3a02eb32e2095f1aa28760e05903a18a5afbff8ef6bd01fb323ab24c97069711'
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
