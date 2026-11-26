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
    version "0.0.15"
    license "MIT"

    base_url = "https://github.com/dahai80/fusion-ops/releases/download/v#{version}"

    on_macos do
        on_arm do
            url "#{base_url}/fusion-ops-#{version}-darwin-arm64.tar.gz"
            sha256 "2f3956314e3af94953011128d1b48a3761a19f482f8bca88901a424bf1d1e9d1"
        end
        on_intel do
            url "#{base_url}/fusion-ops-#{version}-darwin-amd64.tar.gz"
            sha256 "0abd55dafa5b10894b0a9dcbc8bece476cc6215d3690f6fbcbe47011f263e3cc"
        end
    end
    on_linux do
        on_arm do
            url "#{base_url}/fusion-ops-#{version}-linux-arm64.tar.gz"
            sha256 "81d69ca8373eeec2aa10f8f85164f6437683fb6b9e6ec1a78816cb7b27ee4ee4"
        end
        on_intel do
            url "#{base_url}/fusion-ops-#{version}-linux-amd64.tar.gz"
            sha256 "a75a8bc82180df97cff28fedf015c5fc9e985b583f7e71cb8523a0caebd9b2e9"
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
