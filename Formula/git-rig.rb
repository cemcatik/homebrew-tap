class GitRig < Formula
  desc "Git worktree workspace manager for multi-repo development"
  homepage "https://github.com/cemcatik/git-rig"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cemcatik/git-rig/releases/download/v0.7.0/git-rig-aarch64-apple-darwin.tar.xz"
      sha256 "bd9c2d2456f58f97ed0f88d7c493a333fa723938536f1aa4e6fdb228dc4d3214"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cemcatik/git-rig/releases/download/v0.7.0/git-rig-x86_64-apple-darwin.tar.xz"
      sha256 "eec9727c57b2c766a43bd2c866eac5cd25490e21e0546197878b073cbe2ff46d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cemcatik/git-rig/releases/download/v0.7.0/git-rig-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d34b445d153d8cafa3faa0ec7b55deabe474d543c5d243d0f1682e10b70d70d6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cemcatik/git-rig/releases/download/v0.7.0/git-rig-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "333001eb54cb952021f3fe03a1ac59f1dbc7c4e77b68aa0be92b71b62481749c"
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
