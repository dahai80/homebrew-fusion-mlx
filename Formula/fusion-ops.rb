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
    version "0.0.16"
    license "MIT"

    base_url = "https://github.com/dahai80/fusion-ops/releases/download/v#{version}"

    on_macos do
        on_arm do
            url "#{base_url}/fusion-ops-#{version}-darwin-arm64.tar.gz"
            sha256 "6970ee13785d242fd4779d10e3a0a48192a57be25649e93c94bbaf65b0326390"
        end
        on_intel do
            url "#{base_url}/fusion-ops-#{version}-darwin-amd64.tar.gz"
            sha256 "f976ff6718cf77c0afeaf537cc7585b84315d93fb8a0f3c0b340412b06b9e3cb"
        end
    end
    on_linux do
        on_arm do
            url "#{base_url}/fusion-ops-#{version}-linux-arm64.tar.gz"
            sha256 "22a77f827176ff5bf066a4acf47cbb141cd42bf51581a76c572da665300d7678"
        end
        on_intel do
            url "#{base_url}/fusion-ops-#{version}-linux-amd64.tar.gz"
            sha256 "ebaae0373ae266b4f32f63d46f1ec8a21537f35d0577e7468f5ade76134e56ec"
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
