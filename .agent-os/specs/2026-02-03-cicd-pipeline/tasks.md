# Spec Tasks

## Tasks

- [x] 1. Setup GitHub Actions workflow structure
  - [x] 1.1 Create `.github/workflows/` directory
  - [x] 1.2 Create `docker.yml` with trigger events (push main, tags v*, PR)
  - [x] 1.3 Configure permissions and environment variables
  - [x] 1.4 Verify workflow file syntax with `act --list` or push to test branch

- [x] 2. Implement Dockerfile linting job
  - [x] 2.1 Add `lint` job with Hadolint action
  - [x] 2.2 Create `.hadolint.yaml` config (optional, for custom rules)
  - [x] 2.3 Test lint job catches Dockerfile issues

- [x] 3. Implement Docker build job
  - [x] 3.1 Add `build` job with Buildx setup
  - [x] 3.2 Configure GHA cache for layer caching
  - [x] 3.3 Save image as artifact for scan job
  - [x] 3.4 Verify build completes and artifact is uploaded

- [x] 4. Implement security scanning job
  - [x] 4.1 Add `scan` job with Trivy action
  - [x] 4.2 Create `.trivyignore` file for false positives
  - [x] 4.3 Configure severity threshold (CRITICAL, HIGH)
  - [x] 4.4 Add artifact cleanup job
  - [x] 4.5 Test scan blocks on vulnerabilities

- [x] 5. Implement push to registry job
  - [x] 5.1 Add `push` job with GHCR login
  - [x] 5.2 Configure metadata action for semver tags
  - [x] 5.3 Enable multi-arch build (amd64, arm64)
  - [x] 5.4 Add conditional logic (only on main/tags)
  - [x] 5.5 Verify image published to GHCR with correct tags

- [ ] 6. ~~Implement cleanup job~~ (REMOVED - breaks multi-arch images)
  - [ ] ~~6.1 Add `cleanup` job to delete old untagged versions~~
  - [ ] ~~6.2 Configure to keep 3 most recent versions~~
  - [ ] ~~6.3 Verify cleanup runs only on main branch~~
  > **Note:** Cleanup job removed because `delete-package-versions` deletes untagged platform-specific manifests required by multi-arch images. Use manual cleanup or GHCR retention policies instead.

- [x] 7. End-to-end validation
  - [x] 7.1 Test PR workflow (lint + build + scan, no push)
  - [x] 7.2 Test push to main (full pipeline + latest tag)
  - [ ] 7.3 Test tag release (full pipeline + semver tags)
  - [x] 7.4 Verify image pulls correctly from GHCR
