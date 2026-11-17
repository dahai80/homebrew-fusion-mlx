class FusionPluginsEcosystem < Formula
    desc "Fusion plugin ecosystem: registry, lifecycle, MCP server, Claude adaptation"
    homepage "https://github.com/dahai80/fusion-plugins-ecosystem"
    url "https://github.com/dahai80/fusion-plugins-ecosystem/archive/refs/tags/v0.10.0.tar.gz"
    sha256 "f168bff048f800f8c68e3adcc2d1e1a0321fdd3b180b58be646a4a5e821dbad4"
    license "Apache-2.0"
    head "https://github.com/dahai80/fusion-plugins-ecosystem.git", branch: "main"

    depends_on "python@3.12"

    # Install strategy: pip-install the release wheel into a private venv and
    # let pip resolve dependencies from PyPI. Homebrew's
    # virtualenv_install_with_resources only works with py3-none-any wheel
    # resources — platform wheels (pydantic-core, cryptography, cffi,
    # rpds-py, setproctitle) fail under its --no-binary=:all: flag. Resolving
    # from the index picks the prebuilt arm64 wheels instead.
    def install
        venv = virtualenv_create(libexec, "python3.12")
        wheel = "https://github.com/dahai80/fusion-plugins-ecosystem/releases/download/v#{version}/fusion_plugins_ecosystem-#{version}-py3-none-any.whl"
        system libexec/"bin/pip", "-v", "install", wheel
    end

    def caveats
        <<~EOS
            MCP server (stdio for Claude Desktop / Claude Code):
              fusion-plugin-server --transport stdio

            MCP server (HTTP):
              fusion-plugin-server --transport http --port 8765

            Extensions console:
              fusion-plugin-console --port 8795

            Data is stored in ~/.fusion-plugins-ecosystem/
        EOS
    end

    test do
        assert_match version.to_s, shell_output("#{bin}/fusion-plugin-server --version")
        assert_match version.to_s, shell_output("#{bin}/fusion-plugin-console --version")
    end
end
