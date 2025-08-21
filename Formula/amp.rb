# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755749142/amp-darwin-arm64.zip'
  sha256 '95c20feede78cd1745526e81d5cef98f3a537a5bc5003b1de3bc8060cda61744'
  version '0.0.1755749142'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755749142/amp-darwin-arm64.zip'
      sha256 '95c20feede78cd1745526e81d5cef98f3a537a5bc5003b1de3bc8060cda61744'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755749142/amp-darwin-x64.zip'
      sha256 '3f7daf19072ba129c480023583ee5c062df14a997af58ff3c9978dd3b719a5f8'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755749142/amp-linux-arm64'
      sha256 '523332eb87b9f4e0d7d1cfcd58462930155fa5ea9e5d339ec7b3ab6590c0cdbe'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755749142/amp-linux-x64'
      sha256 '05c3760755b303c24ef596d95cc897ba2623526f668d8446e44c51c9dc273f18'
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
