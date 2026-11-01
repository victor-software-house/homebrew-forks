cask "herdr-vsh" do
  version "0.1.11-3"
  sha256 "5f4c787c1878091e35b6e833864d45833d7aa320896ab00f075b90ad3513a2ab"

  url "https://github.com/victor-software-house/herdr-vsh/releases/download/vsh-v#{version}/Herdr-VSH.pkg"
  name "Herdr VSH"
  desc "Herdr desktop app with Ghostty-like terminal rendering"
  homepage "https://github.com/victor-software-house/herdr-vsh"

  livecheck do
    url :url
    regex(/^vsh-v(\d+(?:\.\d+)+-\d+)$/i)
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  pkg "Herdr-VSH.pkg"

  uninstall quit:    "com.victor-software-house.herdr",
            pkgutil: "com.victor-software-house.herdr.pkg",
            delete:  "/Applications/Herdr VSH.app"

  zap trash: "~/.config/herdr-vsh"
end
