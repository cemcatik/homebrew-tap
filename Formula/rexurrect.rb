class Rexurrect < Formula
  desc "Save Rex sessions and recreate them after the Rex server stops"
  homepage "https://github.com/cemcatik/rexurrect"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cemcatik/rexurrect/releases/download/v0.6.0/rexurrect-aarch64-apple-darwin.tar.xz"
      sha256 "0e204688d8f8fc9f9c91813ac9f371b060fffd0b5de8d01b2b078b3174cadf0d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cemcatik/rexurrect/releases/download/v0.6.0/rexurrect-x86_64-apple-darwin.tar.xz"
      sha256 "6d963ca6675cd0a3910564dcc81f81671bcba539109488d42a476e155c118318"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cemcatik/rexurrect/releases/download/v0.6.0/rexurrect-aarch64-unknown-linux-musl.tar.xz"
      sha256 "f137bf5adb9da782cea2cda2a178e74811076fe092d943aff215ca88e7a28e65"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cemcatik/rexurrect/releases/download/v0.6.0/rexurrect-x86_64-unknown-linux-musl.tar.xz"
      sha256 "45990bb57e10d56c31e6d7cb75befe1751adc430c629e2dcf5b74e432e53339f"
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
