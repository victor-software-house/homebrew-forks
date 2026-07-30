# Homebrew formula for the jixiuf/tmux fork.
# Adds kitty keyboard protocol support missing from upstream tmux.
# Upstream fork: https://github.com/jixiuf/tmux
class Tmux < Formula
  desc "Terminal multiplexer (jixiuf fork — kitty keyboard protocol)"
  homepage "https://github.com/jixiuf/tmux"
  # PINNED to a next-3.7 base on purpose — do not bump to a next-3.8 base.
  #
  # Upstream tmux 3.8 breaks iTerm2's control mode (`tmux -CC`): the window never
  # opens and iTerm2 times out after 5s. Verified by A/B on this machine with three
  # identically-built binaries:
  #
  #   next-3.7 + fork kitty patches      -> -CC works
  #   next-3.8 + fork kitty patches      -> -CC hangs
  #   next-3.8 clean upstream, no patches -> -CC hangs
  #
  # So it is upstream, not the fork. tmux/tmux#5135 is the live discussion; the
  # maintainer's position is that old iTerm2 versions cannot handle 3.8's floating
  # panes and that clients must opt into a new `new-layouts` flag, which is not in
  # master yet. iTerm2 3.6.11 (current stable) and 3.7.0beta7 both lack it.
  #
  # Revisit when iTerm2 ships new-layouts support, then move to a 3.8 base.
  url "https://github.com/jixiuf/tmux/archive/78052127d83e317bee59b9c07e4de54b6b89851c.tar.gz"
  version "next-3.7-7805212"
  sha256 "d5d6a17711dfb92c8c94bf996e2fa696e0da021ea1862b5dacabf3cfa49f22f9"
  license "ISC"
  head "https://github.com/jixiuf/tmux.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "pkgconf" => :build
  # On macOS tmux's configure refuses to guess: calloc(3) does not reliably zero
  # allocations there, so it demands an explicit --enable-jemalloc or
  # --disable-jemalloc. Enabling it is the upstream recommendation, and that
  # needs a real jemalloc to link against.
  depends_on "jemalloc"
  depends_on "libevent"
  depends_on "ncurses"
  depends_on "utf8proc"

  conflicts_with "tmux", because: "this formula installs the same binary"

  def install
    system "sh", "autogen.sh"

    args = %W[
      --prefix=#{prefix}
      --enable-utf8proc
      --enable-jemalloc
      --enable-sixel
    ]

    ENV.prepend_path "PKG_CONFIG_PATH", "#{formula_opt_lib("jemalloc")}/pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", "#{formula_opt_lib("libevent")}/pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", "#{formula_opt_lib("ncurses")}/pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", "#{formula_opt_lib("utf8proc")}/pkgconfig"

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      This is the jixiuf fork of tmux with kitty keyboard protocol support.
      It conflicts with the stock homebrew/core tmux formula.

      To switch back to stock tmux:
        brew uninstall victor-software-house/forks/tmux
        brew install tmux
    EOS
  end

  test do
    system bin/"tmux", "-V"
  end
end
