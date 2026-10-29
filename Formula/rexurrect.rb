class Rexurrect < Formula
  desc "Save Rex sessions and recreate them after the Rex server stops"
  homepage "https://github.com/cemcatik/rexurrect"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cemcatik/rexurrect/releases/download/v0.2.1/rexurrect-aarch64-apple-darwin.tar.xz"
      sha256 "1617585b74b230f26c71f528be5d2fb9f4bbe5381d51bea2c308156187056877"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cemcatik/rexurrect/releases/download/v0.2.1/rexurrect-x86_64-apple-darwin.tar.xz"
      sha256 "b2270a2322f76fdec581b29d918e5d1d19c7ffb38973929cc790919e40c53212"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cemcatik/rexurrect/releases/download/v0.2.1/rexurrect-aarch64-unknown-linux-musl.tar.xz"
      sha256 "de055e919e6f4353d890545b1551258941301075b310b6e0c6ba94a70d2f956a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cemcatik/rexurrect/releases/download/v0.2.1/rexurrect-x86_64-unknown-linux-musl.tar.xz"
      sha256 "d411b13760365fc6bf6eda66abde9f454018c53dc632e597509c283a3820369a"
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
