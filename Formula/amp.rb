# frozen_string_literal: true

# Amp CLI - An agentic coding tool, in research preview from Sourcegraph
class Amp < Formula
  desc 'Amp CLI - An agentic coding tool, in research preview from Sourcegraph'
  homepage 'https://ampcode.com'
  url 'https://packages.ampcode.com/binaries/cli/v0.0.1754454080/amp-darwin-arm64.zip'
  sha256 '58061ef3d19973c43ca364df9fe9d37999e4fb00de59772a52a3e0f760196ff9'
  version '0.0.1754454080'

  on_macos do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754454080/amp-darwin-arm64.zip'
      sha256 '58061ef3d19973c43ca364df9fe9d37999e4fb00de59772a52a3e0f760196ff9'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754454080/amp-darwin-x64.zip'
      sha256 '559e92d923d794a5872b51c0dfc02ebb92120783c7c1d44b5089801d37310cae'
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754454080/amp-linux-arm64'
      sha256 'ec97a18bf571025faaa8f597740f897b93ed42ff6705a81de321680f251d3a4d'
    else
      url 'https://packages.ampcode.com/binaries/cli/v0.0.1754454080/amp-linux-x64'
      sha256 'eb0f9afa9b898b3e5af0170e6792fa667698bb71f7cf5dc539bdd0f7d810c9e6'
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
