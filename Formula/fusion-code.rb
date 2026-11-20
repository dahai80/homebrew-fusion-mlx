class FusionCode < Formula
    desc "Local-first AI coding agent — Anthropic-compatible CLI over any endpoint or local MLX"
    homepage "https://github.com/dahai80/fusion-code"
    version "0.8.12"
    license "AGPL-3.0-or-later"

    base_url = "https://github.com/dahai80/fusion-code/releases/download/v#{version}"

    on_macos do
        on_arm do
            url "#{base_url}/fusion-code-#{version}-darwin-arm64.tar.gz"
            sha256 "8b263f4cd8b34bb9b4708d0f79256825ff460ca30f3dc93b57cd1bff95e8e025"
        end
        on_intel do
            url "#{base_url}/fusion-code-#{version}-darwin-x64.tar.gz"
            sha256 "9b397ad32a8036bdabd106320180d0adbd25e57799248bb39cbc4c530dda2bb7"
        end
    end
    on_linux do
        on_arm do
            url "#{base_url}/fusion-code-#{version}-linux-arm64.tar.gz"
            sha256 "aa45a9bdd003e1d947f901f52db9dca4251a927b33c476a6d79bef167c26143d"
        end
        on_intel do
            url "#{base_url}/fusion-code-#{version}-linux-x64.tar.gz"
            sha256 "23fa400a01d8565ba8f6d477851a3fb8779dadb29477e35695d683bfe8bcde9e"
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
