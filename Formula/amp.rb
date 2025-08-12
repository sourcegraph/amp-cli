# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755000478/amp-darwin-arm64.zip'
  sha256 '6a1592f58f6dd3977d1788647a73a7276f3032316e44a5f72e22967702c0a799'
  version '0.0.1755000478'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755000478/amp-darwin-arm64.zip'
      sha256 '6a1592f58f6dd3977d1788647a73a7276f3032316e44a5f72e22967702c0a799'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755000478/amp-darwin-x64.zip'
      sha256 'd350c38548fa420b6d125d8b87e54f73722981e7f5ccd3b57bb0987884c01138'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755000478/amp-linux-arm64'
      sha256 '4dab0fffb8eba7ea4369d37216ae057ffa39bb3a6d6ca93308d2ab10f8d25cc6'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755000478/amp-linux-x64'
      sha256 '63030d036d0981fcd9a5f032e32b1cee55e28ed3bd0a30d53f81a8ab139883ba'
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
