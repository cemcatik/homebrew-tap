class Rexurrect < Formula
  desc "Save Rex sessions and recreate them after the Rex server stops"
  homepage "https://github.com/cemcatik/rexurrect"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cemcatik/rexurrect/releases/download/v0.3.0/rexurrect-aarch64-apple-darwin.tar.xz"
      sha256 "6363fa016554d6f70098abf820d58f9b53ff67a0109c2ead5228a58f15c3bf9d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cemcatik/rexurrect/releases/download/v0.3.0/rexurrect-x86_64-apple-darwin.tar.xz"
      sha256 "5d0160d3ef55f5a45b4cd1bc4e6947f98936db0ecc35baf48c1d62537d96c8d7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cemcatik/rexurrect/releases/download/v0.3.0/rexurrect-aarch64-unknown-linux-musl.tar.xz"
      sha256 "d45727edbbda86fbe33f0e8ed5455fa6482238bdb3a5a0f30a7160ff0f04e3a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cemcatik/rexurrect/releases/download/v0.3.0/rexurrect-x86_64-unknown-linux-musl.tar.xz"
      sha256 "5860731b6439bc1f53720e5532c1623c1306d6b64e4597812f708069c52d3c29"
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
