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
    version "0.0.14"
    license "MIT"

    base_url = "https://github.com/dahai80/fusion-ops/releases/download/v#{version}"

    on_macos do
        on_arm do
            url "#{base_url}/fusion-ops-#{version}-darwin-arm64.tar.gz"
            sha256 "e03a32ec09516cf5f4c59ee5cb228237cd3bc223e0fc0d6850e26063ab0a5dcb"
        end
        on_intel do
            url "#{base_url}/fusion-ops-#{version}-darwin-amd64.tar.gz"
            sha256 "23154949c54304a9bf35df74518a22819db94d8a50c8712ff52da24ae5eb0734"
        end
    end
    on_linux do
        on_arm do
            url "#{base_url}/fusion-ops-#{version}-linux-arm64.tar.gz"
            sha256 "f0c38ee1921d0f07782069b630af7905e906f429a6fca905d0ca7f8fcf82d4a8"
        end
        on_intel do
            url "#{base_url}/fusion-ops-#{version}-linux-amd64.tar.gz"
            sha256 "3415f33de142ba4469182b5f8237a453cf7fbb89977195076243147c4b1cff37"
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
