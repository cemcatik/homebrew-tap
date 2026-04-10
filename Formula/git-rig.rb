class GitRig < Formula
  desc "Git worktree workspace manager for multi-repo development"
  homepage "https://github.com/cemcatik/git-rig"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cemcatik/git-rig/releases/download/v0.6.0/git-rig-aarch64-apple-darwin.tar.xz"
      sha256 "19c930e647fab714d8ec8851d36e74b5dcfbd84a62b65606feda4f03e263739f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cemcatik/git-rig/releases/download/v0.6.0/git-rig-x86_64-apple-darwin.tar.xz"
      sha256 "61b329422c97e6ecdfcf8d4d8437c953a9f840a3efc9af2b9d069bd59f14112d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cemcatik/git-rig/releases/download/v0.6.0/git-rig-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b351a59f9261478132840aede57ee16b6a3d5a88acb22ba170d8031f27cd22a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cemcatik/git-rig/releases/download/v0.6.0/git-rig-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "51693cf2086071311b4d88d99ce2af9b72c83180fdc06933f5f0c482a06215b8"
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
