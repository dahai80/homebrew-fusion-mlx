class FusionCode < Formula
    desc "Local-first AI coding agent — Anthropic-compatible CLI over any endpoint or local MLX"
    homepage "https://github.com/dahai80/fusion-code"
    version "0.8.35"
    license "AGPL-3.0-or-later"

    base_url = "https://github.com/dahai80/fusion-code/releases/download/v#{version}"

    on_macos do
        on_arm do
            url "#{base_url}/fusion-code-#{version}-darwin-arm64.tar.gz"
            sha256 "70890ef51aef75c3aba8837eb951dc7288e21effd2f9209ee5ee6a53445ae0e9"
        end
        on_intel do
            url "#{base_url}/fusion-code-#{version}-darwin-x64.tar.gz"
            sha256 "009f11348cd4f381388f7ec8f2aac7c15d51cf1f7dbe2553f8905a9c7460e32c"
        end
    end
    on_linux do
        on_arm do
            url "#{base_url}/fusion-code-#{version}-linux-arm64.tar.gz"
            sha256 "fbb27f05484d0fae8290145fb6f5ca3c9e261c4ac95ebd648aeba3e7acbe70b9"
        end
        on_intel do
            url "#{base_url}/fusion-code-#{version}-linux-x64.tar.gz"
            sha256 "878aa4f5857597050470324d02342d5bdf6f7265a67d8200cbe6edd80d4ae906"
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
