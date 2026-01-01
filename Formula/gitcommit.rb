class Gitcommit < Formula
  desc "Automated Git workflow tool"
  homepage "https://github.com/CloveTwilight3/GitCommit"
  url "https://github.com/CloveTwilight3/GitCommit/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "05cab3b10a978c16942a15141aa95353ee1531082cfce8266b9ec6560dc231bc"
  license "Estrogen-Source-Available-1.2"
  version "1.1.3"

  depends_on "git"
  depends_on "bash"

  def install
    bin.install "src/linux/gitcommit.sh" => "gitcommit"
  end

  test do
    assert_match "GitCommit v#{version}", shell_output("#{bin}/gitcommit --version")
  end
end
