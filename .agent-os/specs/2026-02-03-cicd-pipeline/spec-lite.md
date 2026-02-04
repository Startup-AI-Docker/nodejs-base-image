# Spec Summary (Lite)

Pipeline CI/CD con GitHub Actions para automatizar build, validación de seguridad y publicación de la imagen Docker base Node.js a GHCR. Incluye Hadolint para linting, Trivy para security scanning, y soporte multi-arch (amd64/arm64). Los PRs validan sin publicar, push a main publica con tag latest, y git tags v* generan releases con semver.
