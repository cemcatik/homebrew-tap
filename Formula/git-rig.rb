class GitRig < Formula
  desc "Git worktree workspace manager for multi-repo development"
  homepage "https://github.com/cemcatik/git-rig"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cemcatik/git-rig/releases/download/v0.3.0/git-rig-aarch64-apple-darwin.tar.xz"
      sha256 "28ccf5b49117d06f4bc7fbf00d6a3e13dae3514cf09934a626175a732b0af77c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cemcatik/git-rig/releases/download/v0.3.0/git-rig-x86_64-apple-darwin.tar.xz"
      sha256 "05a3dcab3f94aaea45d677abc9086c5d388ee4aa173615f0387319ea475b4d43"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cemcatik/git-rig/releases/download/v0.3.0/git-rig-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fd5006b866aa57c32cbdcbcc800ed45a7f08846a8e22faa5d1f15eab2ee5ea9f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cemcatik/git-rig/releases/download/v0.3.0/git-rig-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c42e77b336b5b2ad6b41e727d42c91ded882027b9d72096bc312c8514011d403"
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
