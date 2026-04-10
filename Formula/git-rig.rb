class GitRig < Formula
  desc "Git worktree workspace manager for multi-repo development"
  homepage "https://github.com/cemcatik/git-rig"
  version "0.6.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cemcatik/git-rig/releases/download/v0.6.2/git-rig-aarch64-apple-darwin.tar.xz"
      sha256 "ded6f12c7992f0cda4c7b3ad6b075ad6851f99db166cc294c14bf42057bcf0da"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cemcatik/git-rig/releases/download/v0.6.2/git-rig-x86_64-apple-darwin.tar.xz"
      sha256 "a5e809fd49a44c198af2884f1a6e28092205c9da77510f1b2ac4bfebb1c1bc91"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cemcatik/git-rig/releases/download/v0.6.2/git-rig-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4d927f36fd4c393bbd883b6e4c36c772da8cb0f4640c6333a4a568b7855650f3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cemcatik/git-rig/releases/download/v0.6.2/git-rig-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "de0215345dd8013231e7358153278367c79e38cbbf25dcd3538f39c77aa0d8e1"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "git-rig" if OS.mac? && Hardware::CPU.arm?
    bin.install "git-rig" if OS.mac? && Hardware::CPU.intel?
    bin.install "git-rig" if OS.linux? && Hardware::CPU.arm?
    bin.install "git-rig" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
