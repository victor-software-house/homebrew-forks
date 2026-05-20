# Homebrew formula for the jixiuf/tmux fork.
# Adds kitty keyboard protocol support missing from upstream tmux.
# Upstream fork: https://github.com/jixiuf/tmux
class Tmux < Formula
  desc "Terminal multiplexer (jixiuf fork — kitty keyboard protocol)"
  homepage "https://github.com/jixiuf/tmux"
  url "https://github.com/jixiuf/tmux/archive/3c4cd61de204619c4a45e3fc0ffc3624a4ac20a5.tar.gz"
  version "next-3.7-3c4cd61"
  sha256 "9959e2ac17d0b4b2dfe263f4fe845cdb8660e6e8e3a77731421b90c4f3ee33f3"
  license "ISC"
  head "https://github.com/jixiuf/tmux.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "bison" => :build
  depends_on "libevent"
  depends_on "ncurses"
  depends_on "utf8proc"

  conflicts_with "tmux", because: "this formula installs the same binary"

  def install
    system "sh", "autogen.sh"

    args = %W[
      --prefix=#{prefix}
      --enable-utf8proc
    ]

    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["libevent"].opt_lib}/pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["ncurses"].opt_lib}/pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["utf8proc"].opt_lib}/pkgconfig"

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
