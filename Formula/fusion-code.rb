class FusionCode < Formula
    desc "Local-first AI coding agent — Anthropic-compatible CLI over any endpoint or local MLX"
    homepage "https://github.com/dahai80/fusion-code"
    version "0.8.18"
    license "AGPL-3.0-or-later"

    base_url = "https://github.com/dahai80/fusion-code/releases/download/v#{version}"

    on_macos do
        on_arm do
            url "#{base_url}/fusion-code-#{version}-darwin-arm64.tar.gz"
            sha256 "de0488397e741afde52e13a4b14e658bb366e1688ea95c01033c6afccc6dc53d"
        end
        on_intel do
            url "#{base_url}/fusion-code-#{version}-darwin-x64.tar.gz"
            sha256 "1ebe5dba4fcc2b3b39f1bb6e75979afb1814397c754581c9b9be0098941cbc68"
        end
    end
    on_linux do
        on_arm do
            url "#{base_url}/fusion-code-#{version}-linux-arm64.tar.gz"
            sha256 "bc94f780740fa72a4f631d0d13a75863d3fbe354533c73680f7b3b8ebf88bd5e"
        end
        on_intel do
            url "#{base_url}/fusion-code-#{version}-linux-x64.tar.gz"
            sha256 "90e8830f854e91cd0cecb64e15e741d37c264e9c6aa4078a20221b8499d69097"
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
