class GitRig < Formula
  desc "Git worktree workspace manager for multi-repo development"
  homepage "https://github.com/cemcatik/git-rig"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cemcatik/git-rig/releases/download/v0.5.0/git-rig-aarch64-apple-darwin.tar.xz"
      sha256 "ff291c018f39baa3d458b7cd044fcf5c83c04bbe9350e832ca9da20aa146dcb4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cemcatik/git-rig/releases/download/v0.5.0/git-rig-x86_64-apple-darwin.tar.xz"
      sha256 "d4060d472a3370ee761332ae304148113efc0035525e849b0037228afe35a70a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cemcatik/git-rig/releases/download/v0.5.0/git-rig-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d88577451c4a17462a89f00e6bf4843d998d70fdd7be406538dc574869b9e535"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cemcatik/git-rig/releases/download/v0.5.0/git-rig-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "02743097666831ee00bc2b3fe69376ae3206a5bf17c0c082c5a9f4a8c7798407"
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
