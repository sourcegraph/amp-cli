# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755705948/amp-darwin-arm64.zip'
  sha256 '2c07c13d53c6ce20c738bbdcf02d2417b3375cb9509119b8823d2bf2c8adaffd'
  version '0.0.1755705948'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755705948/amp-darwin-arm64.zip'
      sha256 '2c07c13d53c6ce20c738bbdcf02d2417b3375cb9509119b8823d2bf2c8adaffd'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755705948/amp-darwin-x64.zip'
      sha256 '5a0b8654a605250d7860a3ae71fc7b076ff97e4d3578a539c4ca6e51babf3489'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755705948/amp-linux-arm64'
      sha256 '7727880da82d26e7057e410614ce8e00832abd552d6dabeed3399cafe0d8cc43'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755705948/amp-linux-x64'
      sha256 'fcc967246012f6c7cc5bd844d35650b524c5bac35d0be57368b7aa6a8f0971c1'
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
