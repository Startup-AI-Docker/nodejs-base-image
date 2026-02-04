# Technical Specification

This is the technical specification for the spec detailed in @.agent-os/specs/2026-02-03-cicd-pipeline/spec.md

## Technical Requirements

### Workflow Structure

```
.github/workflows/docker.yml
```

### Trigger Events

- `push` to `main` branch → build + scan + push (latest, sha)
- `push` tags `v*` → build + scan + push (semver tags)
- `pull_request` to `main` → build + scan only (no push)

### Jobs Pipeline

```
lint → build → scan → push → cleanup
```

1. **lint**: Hadolint validation
2. **build**: Docker Buildx with GHA cache, save artifact
3. **scan**: Trivy vulnerability scan (CRITICAL, HIGH)
4. **push**: Multi-arch build and push to GHCR (conditional)
5. **cleanup**: Delete old untagged versions (keep 3)

### Permissions Required

```yaml
permissions:
  contents: read
  packages: write
```

### Environment Variables

```yaml
env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}
```

### Image Tagging Strategy

| Event | Tags Generated |
|-------|---------------|
| Push to main | `latest`, `main`, `sha-{commit}` |
| Tag v1.2.3 | `1.2.3`, `1.2`, `1`, `sha-{commit}` |
| PR | No push (build only) |

### Multi-Architecture Support

- `linux/amd64` - Standard x86_64
- `linux/arm64` - Apple Silicon, AWS Graviton

### Security Scanning Configuration

- Scanner: Trivy v0.28.0+
- Severity threshold: CRITICAL, HIGH
- Exit code: 1 (fail on findings)
- Ignore file: `.trivyignore` (for false positives)

### Caching Strategy

- Type: GitHub Actions cache (`type=gha`)
- Mode: max (cache all layers)
- Shared between build and push jobs

### Artifact Strategy

- Build job saves image as tar artifact
- Scan job loads artifact for scanning
- Cleanup job deletes artifact after scan
- Retention: 1 day

## GitHub Actions Used

| Action | Version | Purpose |
|--------|---------|---------|
| `actions/checkout` | v4 | Clone repository |
| `docker/setup-buildx-action` | v3 | Enable Buildx |
| `docker/setup-qemu-action` | v3 | Multi-arch emulation |
| `docker/login-action` | v3 | GHCR authentication |
| `docker/metadata-action` | v5 | Generate tags/labels |
| `docker/build-push-action` | v5 | Build and push |
| `hadolint/hadolint-action` | v3.1.0 | Dockerfile linting |
| `aquasecurity/trivy-action` | v0.28.0 | Security scanning |
| `actions/upload-artifact` | v4 | Save build artifact |
| `actions/download-artifact` | v4 | Load build artifact |
| `geekyeggo/delete-artifact` | v5 | Cleanup artifacts |
| `actions/delete-package-versions` | v5 | Cleanup old images |

## Files to Create

1. `.github/workflows/docker.yml` - Main workflow file
2. `.trivyignore` - Trivy ignore file for false positives (empty initially)
3. `.hadolint.yaml` - Hadolint configuration (optional, for custom rules)

## Conditional Logic

### Push Job Condition

```yaml
if: github.event_name == 'push' && (github.ref == 'refs/heads/main' || startsWith(github.ref, 'refs/tags/v'))
```

### Cleanup Job Condition

```yaml
if: github.event_name == 'push' && github.ref == 'refs/heads/main'
```

### Latest Tag Condition

```yaml
latest=${{ github.ref == 'refs/heads/main' }}
```
