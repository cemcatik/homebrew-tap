class Rexurrect < Formula
  desc "Save Rex sessions and recreate them after the Rex server stops"
  homepage "https://github.com/cemcatik/rexurrect"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cemcatik/rexurrect/releases/download/v0.2.0/rexurrect-aarch64-apple-darwin.tar.xz"
      sha256 "228f4cfa8ed812086757755c84c3f42078bf288ff6960db0da7c4d45d94649b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cemcatik/rexurrect/releases/download/v0.2.0/rexurrect-x86_64-apple-darwin.tar.xz"
      sha256 "169f9e658067bc3b23fae1d3ed9a7ee642122270b5f3d20a1ddec12aa4d268fd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cemcatik/rexurrect/releases/download/v0.2.0/rexurrect-aarch64-unknown-linux-musl.tar.xz"
      sha256 "bf97d67ffa3cc73df9ecf3f11a6904f8dcb7cfa95bc3c4638458587cfd009365"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cemcatik/rexurrect/releases/download/v0.2.0/rexurrect-x86_64-unknown-linux-musl.tar.xz"
      sha256 "bdb727a1e17bdf06ea45b1e3806e957475760c944a959ab7b03df7840d25432f"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "rexurrect"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rexurrect"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "rexurrect"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rexurrect"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
