# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754118204/amp-darwin-arm64.zip'
  sha256 '8625a19caf29a19dfa3efddc0f8b6c0efcebda8a6d75f64652ac15c8207c99f3'
  version '0.0.1754118204'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754118204/amp-darwin-arm64.zip'
      sha256 '8625a19caf29a19dfa3efddc0f8b6c0efcebda8a6d75f64652ac15c8207c99f3'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754118204/amp-darwin-x64.zip'
      sha256 '30b12d24b99d721eba8203f96c5a3f395d2847342f8d97cc7181c653c413eb0a'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754118204/amp-linux-arm64'
      sha256 '5a4154ce26b0f9d02020c1d6946e09251d3854dcda8d98d13211e22a3ce3602f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754118204/amp-linux-x64'
      sha256 '90095a1ab337a001520f9812b3211332916e486c8d9d44f4841d0c96e40c28ff'
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
