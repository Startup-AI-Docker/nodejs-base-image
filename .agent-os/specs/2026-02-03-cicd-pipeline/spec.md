# Spec Requirements Document

> Spec: CI/CD Pipeline for Node.js Base Image
> Created: 2026-02-03

## Overview

Implementar un pipeline de CI/CD con GitHub Actions que automatice el build, validación de seguridad y publicación de la imagen Docker base de Node.js a GitHub Container Registry (GHCR), habilitando releases versionados y actualizaciones automáticas para proyectos downstream.

## User Stories

### Build Automatizado en PRs

As a backend developer, I want to validate that my Dockerfile changes build correctly before merging, so that I can catch build errors early.

El desarrollador crea un PR con cambios al Dockerfile. El pipeline ejecuta lint (Hadolint) y build automáticamente. Si hay errores de lint o build, el PR se bloquea hasta que se corrijan. El desarrollador recibe feedback inmediato sobre la calidad del Dockerfile.

### Release Versionado

As a platform engineer, I want to create versioned releases of the base image using git tags, so that downstream projects can pin to specific versions.

El engineer crea un tag `v1.0.0`. El pipeline detecta el tag, ejecuta validaciones, y publica la imagen con tags semver (`1.0.0`, `1.0`, `1`). Los proyectos downstream pueden actualizar su base image referenciando la nueva versión.

### Seguridad Continua

As a security engineer, I want all images scanned for vulnerabilities before publishing, so that we don't ship images with known CVEs.

Cada build ejecuta Trivy scan. Si se detectan vulnerabilidades CRITICAL o HIGH, el pipeline falla y no publica. El equipo recibe notificación para remediar antes de que la imagen llegue a producción.

## Spec Scope

1. **GitHub Actions Workflow** - Archivo `.github/workflows/docker.yml` con jobs de lint, build, scan y push
2. **Dockerfile Linting** - Validación con Hadolint para mejores prácticas de Docker
3. **Security Scanning** - Escaneo de vulnerabilidades con Trivy antes de publicar
4. **Multi-arch Build** - Soporte para linux/amd64 y linux/arm64
5. **Semantic Versioning Tags** - Tags automáticos basados en git tags (v1.0.0 → 1.0.0, 1.0, 1, latest)

## Out of Scope

- Image signing con Cosign (fase futura)
- Notificaciones a Slack/Discord
- Deployment automático a clusters
- Matrix builds para múltiples versiones de Node.js
- **Cleanup automático de versiones viejas** - Removido porque `delete-package-versions` elimina los manifests de plataforma (amd64/arm64) que son requeridos por imágenes multi-arch. Usar cleanup manual via GHCR UI o políticas de retención a nivel organización.

## Expected Deliverable

1. Pipeline ejecuta exitosamente en PRs (lint + build + scan) sin publicar
2. Push a `main` publica imagen con tag `latest` y `sha-{commit}`
3. Tag `v*` publica imagen con tags semver correspondientes a GHCR
