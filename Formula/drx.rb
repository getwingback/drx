class Drx < Formula
  desc "Shadow Twin CLI: know whether every app and database can be rebuilt"
  homepage "https://github.com/getwingback/drx"
  version "0.1.0"

  on_macos do
    on_arm do
      url "https://github.com/getwingback/drx/releases/download/v0.1.0/drx_0.1.0_darwin_arm64.tar.gz"
      sha256 "3275a9834dc659440e26e8e980b4eaf1704f9bada73b786a2ac368a18e060313"
    end
    on_intel do
      url "https://github.com/getwingback/drx/releases/download/v0.1.0/drx_0.1.0_darwin_amd64.tar.gz"
      sha256 "094ecee7ae13591d7487cf8b771c58eaca21a379e003ea553dae007cee9d4a79"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/getwingback/drx/releases/download/v0.1.0/drx_0.1.0_linux_arm64.tar.gz"
      sha256 "1767191b3e7aa7917e38e2e045d6d047f1cf41f33f95a3d53029bf4ebc82e4be"
    end
    on_intel do
      url "https://github.com/getwingback/drx/releases/download/v0.1.0/drx_0.1.0_linux_amd64.tar.gz"
      sha256 "e3ce1dd57eb9452dceeca971ca3d772835b93a0afaac2914f1b3ac8f1e71e778"
    end
  end

  def install
    bin.install "drx"
  end

  test do
    assert_match "0.1.0", shell_output("#{bin}/drx --version")
  end
end
