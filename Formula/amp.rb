# frozen_string_literal: true

# Amp CLI - AI-powered coding assistant
class Amp < Formula
  desc 'Amp CLI - AI-powered coding assistant'
  homepage 'https://github.com/sourcegraph/amp-packages'
  url '                https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753992324-g10d932/amp-darwin-arm64'
  sha256 'f9d86d414936c4cf1ea4fb08aee1e0944674360e6728258432227cf4cff971d3'
  version '0.0.1753992324-g10d932'

  on_macos do
    if Hardware::CPU.arm?
      url '                https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753992324-g10d932/amp-darwin-arm64'
      sha256 'f9d86d414936c4cf1ea4fb08aee1e0944674360e6728258432227cf4cff971d3'
    else
      url '                https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753992324-g10d932/amp-darwin-x64'
      sha256 'c54de14f742958d6650c71fd2461ede4f65f8e4e4318a1ea7f80af81e9ac1e5e'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url '                https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753992324-g10d932/amp-linux-arm64'
      sha256 'af8f55a35ebf6f76fec4f6f6d0d27c16625727231cc5884297b3a6a58184f77f'
    else
      url '                https://github.com/sourcegraph/amp-packages/releases/download/v0.0.1753992324-g10d932/amp-linux-x64'
      sha256 '500bfb66857ba6cc6e697f12512184fee2eb83477269e646bf05ff3dfca0e596'
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
