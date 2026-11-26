class FusionCode < Formula
    desc "Local-first AI coding agent — Anthropic-compatible CLI over any endpoint or local MLX"
    homepage "https://github.com/dahai80/fusion-code"
    version "0.8.27"
    license "AGPL-3.0-or-later"

    base_url = "https://github.com/dahai80/fusion-code/releases/download/v#{version}"

    on_macos do
        on_arm do
            url "#{base_url}/fusion-code-#{version}-darwin-arm64.tar.gz"
            sha256 "8a9776386c8f9885c1e8584d4dafb05d487b507f6747c9e52ca2d034b4b37811"
        end
        on_intel do
            url "#{base_url}/fusion-code-#{version}-darwin-x64.tar.gz"
            sha256 "f1351e2b6721a1deb79a1d54158b1cabf8c5a5a8be025205316218fae4603ee8"
        end
    end
    on_linux do
        on_arm do
            url "#{base_url}/fusion-code-#{version}-linux-arm64.tar.gz"
            sha256 "79bcf3ee1ecac4a8cd0b3b87c6de174023aece7fcfbc5cc310054e6a84ba4e0a"
        end
        on_intel do
            url "#{base_url}/fusion-code-#{version}-linux-x64.tar.gz"
            sha256 "5e2b9250aa4eaabdbf83f22c5a54f3d5e26cf59929fe667eda422bdddb89e13c"
        end
    end

    def install
        # package-release.sh ships the binary as fusion-code-<os>-<arch> at
        # the archive root (plus FUSION.rules.example); install as plain
        # fusion-code.
        os = OS.mac? ? "darwin" : "linux"
        arch = Hardware::CPU.arm? ? "arm64" : "x64"
        bin.install "fusion-code-#{os}-#{arch}" => "fusion-code"
    end

    def caveats
        <<~EOS
            Configure an Anthropic-compatible endpoint + key (the only required setup):
              export FUSION_BASE_URL="https://api.anthropic.com"
              export FUSION_CLIENT_KEY="sk-..."

            Local MLX inference is opt-in:
              export FUSION_MLX_ENABLED=1
        EOS
    end

    test do
        assert_match version.to_s, shell_output("#{bin}/fusion-code --version")
    end
end
