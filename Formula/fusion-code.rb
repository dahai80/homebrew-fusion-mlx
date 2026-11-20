class FusionCode < Formula
    desc "Local-first AI coding agent — Anthropic-compatible CLI over any endpoint or local MLX"
    homepage "https://github.com/dahai80/fusion-code"
    version "0.8.9"
    license "AGPL-3.0-or-later"

    base_url = "https://github.com/dahai80/fusion-code/releases/download/v#{version}"

    on_macos do
        on_arm do
            url "#{base_url}/fusion-code-#{version}-darwin-arm64.tar.gz"
            sha256 "c95f2398ba1c28a56c942cf8525672a6ab37ddc71224a8b19133162df0dd425a"
        end
        on_intel do
            url "#{base_url}/fusion-code-#{version}-darwin-x64.tar.gz"
            sha256 "8f911ec26cc07af6a853b9a065475d3fd00c70b639ae1907cce28c84fb0b166f"
        end
    end
    on_linux do
        on_arm do
            url "#{base_url}/fusion-code-#{version}-linux-arm64.tar.gz"
            sha256 "6ba97cbc6124b9d6ea0797e12d5e21b8f5611a8858d4151713427b656bd8e109"
        end
        on_intel do
            url "#{base_url}/fusion-code-#{version}-linux-x64.tar.gz"
            sha256 "39d42e33743104dc35a3e5865474a2fadaaaea29f2a9ad34dea6e8f6a260eb0f"
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
