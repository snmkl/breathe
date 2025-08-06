cask "breathe" do
  version "1.0.0"
  sha256 "79bf4466013ab1deb2020e3ce52fe5e3e27bd1dc270d8495d34a96a35bf2c7fd"

  url "https://github.com/snmkl/breathe/releases/download/v#{version}/Breathe.app.zip"
  name "Breathe"
  desc "Simple 4-7-8 breathing pattern guide for macOS menu bar"
  homepage "https://github.com/snmkl/breathe"

  depends_on macos: ">= :big_sur"

  app "Breathe.app"

  zap trash: [
    "~/Library/Preferences/com.breathe.app.plist",
  ]
end
