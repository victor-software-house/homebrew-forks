cask "herdr-vsh" do
  version "0.1.9-1"
  sha256 "27c8e660d07d37201a732fade905456bfef62e23dce31e0da7d9c5837e83a810"

  url "https://github.com/victor-software-house/herdr-app/releases/download/vsh-v#{version}/Herdr-VSH.pkg"
  name "Herdr VSH"
  desc "Herdr desktop app with Ghostty-like terminal rendering"
  homepage "https://github.com/victor-software-house/herdr-app"

  livecheck do
    url :url
    regex(/^vsh-v(\d+(?:\.\d+)+-\d+)$/i)
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: ">= :tahoe"

  pkg "Herdr-VSH.pkg"

  uninstall quit:    "com.victor-software-house.herdr",
            pkgutil: "com.victor-software-house.herdr.pkg",
            delete:  "/Applications/Herdr VSH.app"

  zap trash: "~/.config/herdr-vsh"
end
