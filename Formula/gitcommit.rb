class Gitcommit < Formula
  desc "Automated Git workflow tool"
  homepage "https://github.com/CloveTwilight3/GitCommit"
  url "https://github.com/CloveTwilight3/GitCommit/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "" # This will be calculated during release
  license "Estrogen-Source-Available-1.2"
  version "1.1.0"

  depends_on "git"
  depends_on "bash"

  def install
    bin.install "src/linux/gitcommit.sh" => "gitcommit"
  end

  test do
    assert_match "GitCommit v#{version}", shell_output("#{bin}/gitcommit --version")
  end
end