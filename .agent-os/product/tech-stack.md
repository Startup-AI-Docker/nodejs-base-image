# Technical Stack

## Container

- **Base Image:** Alpine Linux (latest stable)
- **Runtime:** Node.js 22 LTS
- **Package Manager:** npm
- **Container Registry:** GitHub Container Registry (ghcr.io)

## Build & CI/CD

- **Dockerfile Strategy:** Multi-stage builds
- **CI/CD Platform:** GitHub Actions
- **Vulnerability Scanning:** Trivy / Grype
- **Image Signing:** Cosign (Sigstore)

## Development

- **Version Control:** Git
- **Repository:** GitHub
- **Branching Strategy:** Feature branches → main
- **Release Strategy:** Semantic versioning via git tags

## Security

- **Base OS Updates:** Alpine security patches
- **Dependency Auditing:** npm audit + Snyk
- **Runtime User:** Non-root (node user)
- **File Permissions:** Restrictive defaults

## Documentation

- **Format:** Markdown
- **Location:** Repository README + .agent-os/product/
