# Homebrew formula for the jixiuf/tmux fork.
# Adds kitty keyboard protocol support missing from upstream tmux.
# Upstream fork: https://github.com/jixiuf/tmux
class Tmux < Formula
  desc "Terminal multiplexer (jixiuf fork — kitty keyboard protocol)"
  homepage "https://github.com/jixiuf/tmux"
  url "https://github.com/jixiuf/tmux/archive/f0703fe099cbc82838a7a73cf981b1a1bd2be3d3.tar.gz"
  version "next-3.8-f0703fe"
  sha256 "d4d744149e53622f4f26bf831a2dd981e5562e8050eaf8b81d3617895e62a74a"
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
