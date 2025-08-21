# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755734422/amp-darwin-arm64.zip'
  sha256 'ac6d6264ec3727f648a34c41d666bf0df9264ca92f97efaba82e639dbb3dba0c'
  version '0.0.1755734422'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755734422/amp-darwin-arm64.zip'
      sha256 'ac6d6264ec3727f648a34c41d666bf0df9264ca92f97efaba82e639dbb3dba0c'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755734422/amp-darwin-x64.zip'
      sha256 'aa7c4f8e5dcd9be453c4b81f695df7a8b25a236a2afef2c81c5aa73db4ff810c'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755734422/amp-linux-arm64'
      sha256 'de631845cd85839a4024b37d731ff21c576c86f66c87f97bacf9cf8b403fd890'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755734422/amp-linux-x64'
      sha256 '111a9ddd06ca8e75ff5a654e96ca084a0f062c21eb2d08fd9e6d626e4cdd6a08'
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
