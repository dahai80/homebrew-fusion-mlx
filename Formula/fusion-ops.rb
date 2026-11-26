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
    version "0.0.13"
    license "MIT"

    base_url = "https://github.com/dahai80/fusion-ops/releases/download/v#{version}"

    on_macos do
        on_arm do
            url "#{base_url}/fusion-ops-#{version}-darwin-arm64.tar.gz"
            sha256 "e83ae564e8e30fb2503aa2ee1975509f953c007c0b26190af1a30bfed5c64204"
        end
        on_intel do
            url "#{base_url}/fusion-ops-#{version}-darwin-amd64.tar.gz"
            sha256 "59cd1f81e0007abdc3ad0865f4126253fce75c88651efc7d621d6f2049cd295b"
        end
    end
    on_linux do
        on_arm do
            url "#{base_url}/fusion-ops-#{version}-linux-arm64.tar.gz"
            sha256 "75633b79bcbd716d528dbfbac67872eae2d4f01a437c9f3a172f0a1b6aec9545"
        end
        on_intel do
            url "#{base_url}/fusion-ops-#{version}-linux-amd64.tar.gz"
            sha256 "d244a1fcad7d88e45010c0bca47558da07821b325855143905c96338c3c1ae65"
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
