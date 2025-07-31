class Amp < Formula
  desc "Amp CLI - AI-powered coding assistant"
  homepage "https://github.com/sourcegraph/amp-cli"
  url "https://github.com/sourcegraph/amp-cli/releases/download/v1.0.0/amp-darwin-arm64.tar.gz"
  sha256 "REPLACE_WITH_ACTUAL_SHA256"
  version "0.0.1753935142-gd618e6"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sourcegraph/amp-cli/releases/download/v1.0.0/amp-darwin-arm64.tar.gz"
      sha256 "REPLACE_WITH_ARM64_SHA256"
    else
      url "https://github.com/sourcegraph/amp-cli/releases/download/v1.0.0/amp-darwin-amd64.tar.gz"
      sha256 "REPLACE_WITH_AMD64_SHA256"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sourcegraph/amp-cli/releases/download/v1.0.0/amp-linux-arm64.tar.gz"
      sha256 "REPLACE_WITH_LINUX_ARM64_SHA256"
    else
      url "https://github.com/sourcegraph/amp-cli/releases/download/v1.0.0/amp-linux-amd64.tar.gz"
      sha256 "REPLACE_WITH_LINUX_AMD64_SHA256"
    end
  end

  depends_on "ripgrep"

  def install
    bin.install "amp"
  end

  test do
    system "#{bin}/amp", "--version"
  end
end
