# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1755360293/amp-darwin-arm64.zip'
  sha256 '1d4205ae42ea21abedef23b3c12765e778e3d2571b4994a4f5ef45b67dfd21f1'
  version '0.0.1755360293'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755360293/amp-darwin-arm64.zip'
      sha256 '1d4205ae42ea21abedef23b3c12765e778e3d2571b4994a4f5ef45b67dfd21f1'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755360293/amp-darwin-x64.zip'
      sha256 '46860975715afb8639c0bd7799046d2d1a64f4203fd35f7c76990c489e3116e4'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755360293/amp-linux-arm64'
      sha256 'f682a767983e0d82a65ef81e10864cfc2e2c52dae449202f4a23601d83f90540'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1755360293/amp-linux-x64'
      sha256 '9b387b3c25945e27dad717c98d3766eca1b6e98d538e9a6d293d41e90f358f1d'
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
