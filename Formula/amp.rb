# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754425175/amp-darwin-arm64.zip'
  sha256 '488acefba953f5715c307775b951c167b0af935ac0384ce53d4924804d97ce80'
  version '0.0.1754425175'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754425175/amp-darwin-arm64.zip'
      sha256 '488acefba953f5715c307775b951c167b0af935ac0384ce53d4924804d97ce80'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754425175/amp-darwin-x64.zip'
      sha256 '3d09d6eb47eb847a75e78e9953cab658306c46c298f99dba6f9e73388eca0da5'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754425175/amp-linux-arm64'
      sha256 'ef0fafd705bf5672adc0e61f2e2331ff12ec5972c7661510f42953ba7753c66f'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754425175/amp-linux-x64'
      sha256 'abaa95f3888b968d397eaa5edf305349898f6d1ab2ef2858ab9ce7dcbf3de4fa'
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
