class Rexurrect < Formula
  desc "Save Rex sessions and recreate them after the Rex server stops"
  homepage "https://github.com/cemcatik/rexurrect"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cemcatik/rexurrect/releases/download/v0.4.0/rexurrect-aarch64-apple-darwin.tar.xz"
      sha256 "da8dd157f99665d5ce575f7c5c0d1656d3923f6b616a399f7632ce97ac338e2c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cemcatik/rexurrect/releases/download/v0.4.0/rexurrect-x86_64-apple-darwin.tar.xz"
      sha256 "96585397e6c7ac44fc14930fc53f3f252d3c147df42c34e9b19f137837324cb4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cemcatik/rexurrect/releases/download/v0.4.0/rexurrect-aarch64-unknown-linux-musl.tar.xz"
      sha256 "cb4c9ab1ebf6fa4d8b759ffd8bf046eb158f141181c8be71684a049132ad93c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cemcatik/rexurrect/releases/download/v0.4.0/rexurrect-x86_64-unknown-linux-musl.tar.xz"
      sha256 "d4023856dc6c67e5cc64f7a2564bf0a8c6fe32ac8b372d53cbf3b34e89528a4e"
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
