# Homebrew formula for fusion-ops — source of truth lives in the
# fusion-ops repo (packaging/homebrew/) and is copied verbatim into
# dahai80/homebrew-fusion-mlx on each release with the real sha256s.
#
# Static Go binaries (CGO_ENABLED=0) built by scripts/package-release.sh
# and attached to the GitHub release. The tarball ships five binaries:
# fusion-ops (API server), fusion-ops-job (one-shot jobs), fusion-ops-probe
# (blackbox site-health probe), fusion-broker (WSS device broker) and
# migrate (schema migrations).

class FusionOps < Formula
    desc "Fusion ops-data flywheel — ops store API, broker, probe and jobs"
    homepage "https://github.com/dahai80/fusion-ops"
    version "0.0.9"
    license "MIT"

    base_url = "https://github.com/dahai80/fusion-ops/releases/download/v#{version}"

    on_macos do
        on_arm do
            url "#{base_url}/fusion-ops-#{version}-darwin-arm64.tar.gz"
            sha256 "44663de5f1c1520a58bf57da7f14cb684bd54502626f68d803bee7479f4e7307"
        end
        on_intel do
            url "#{base_url}/fusion-ops-#{version}-darwin-amd64.tar.gz"
            sha256 "37e4ae50a239c53bccb1c68e508a922a6a7994181296333d3fb03fa19adde1a4"
        end
    end
    on_linux do
        on_arm do
            url "#{base_url}/fusion-ops-#{version}-linux-arm64.tar.gz"
            sha256 "92697c20a8e43da3e3625c5b82c7c1d48ca8851c1337e04ae91df355aabe1ae7"
        end
        on_intel do
            url "#{base_url}/fusion-ops-#{version}-linux-amd64.tar.gz"
            sha256 "db052b950b2085ef5037f6ec8207e5c97f15d0d188fe813d79af6b7f16b01d36"
        end
    end

    def install
        bin.install "fusion-ops", "fusion-ops-job", "fusion-ops-probe", "fusion-broker", "migrate"
    end

    def caveats
        <<~EOS
            Binaries installed: fusion-ops, fusion-ops-job, fusion-ops-probe,
            fusion-broker, migrate. All read FUSION_OPS_DATABASE_URL (postgres)
            and never start without it; see README + docs/operations.md:
              https://github.com/dahai80/fusion-ops#configuration
        EOS
    end

    test do
        # flag package prints usage and exits 2 on -h; proves the binary
        # runs and links correctly.
        output = shell_output("#{bin}/fusion-ops-probe -h", 2)
        assert_match "run one probe round", output
    end
end
