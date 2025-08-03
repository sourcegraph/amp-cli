# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754227594/amp-darwin-arm64.zip'
  sha256 'e77e1cfaaaa1e8f04527f4e3d082c8665774036f3e4aa9a5bf031fc7323fa811'
  version '0.0.1754227594'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754227594/amp-darwin-arm64.zip'
      sha256 'e77e1cfaaaa1e8f04527f4e3d082c8665774036f3e4aa9a5bf031fc7323fa811'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754227594/amp-darwin-x64.zip'
      sha256 '8bee197b407b9f5f07510b1e4d9d799121933e470641c1f08d90efc92d5af075'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754227594/amp-linux-arm64'
      sha256 '620fac65d00947b6946f369a0f8e87d917aaae5335a039dbaac454ecca7a5812'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754227594/amp-linux-x64'
      sha256 'bfc77629f23d972ffc643084874ecec8061398e307e29cd56e88e616eb553c3d'
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
