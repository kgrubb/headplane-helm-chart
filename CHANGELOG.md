# Changelog

## [Unreleased]

## [0.3.1] - 2026-10-23

### Fixed
- bump Headplane app image to 0.8.2



## [0.3.0] - 2026-10-21

### Added
- optional `config.integration.agent.tailscaleNetns` passthrough into Headplane config ([#2](https://github.com/kgrubb/headplane-helm-chart/pull/2))



## [0.2.0] - 2026-10-20

### Added
- bump Headplane app image to 0.8.1



## [0.1.0] - 2026-10-20

### Added
- auto-bump chart on new Headplane releases ([#1](https://github.com/kgrubb/headplane-helm-chart/pull/1))
  - add daily `upgrade-headplane` workflow + script (same pattern as stalwart/nostalgiatv) so new `tale/headplane` releases bump `appVersion` / image tag and dispatch `release.yml`
  - map upstream major → `feat!(image)`, minor → `feat(image)`, patch → `fix(image)` so chart semver follows
  - note automatic upstream sync in the README
- auto-bump chart on new Headplane releases



## [0.0.6] - 2026-10-02

### Fixed
- always set kubernetes.pod_name in config



## [0.0.5] - 2026-10-02

### Fixed
- verify Artifact Hub publisher and use official logo



## [0.0.4] - 2026-10-02

### Fixed
- harden security context and probes



## [0.0.3] - 2026-10-02

### Changed
- drop scaffold references to other charts



## [0.0.2] - 2026-10-01

### Fixed
- allow unsigned chart releases without GPG secret
- seed changelog with Unreleased section
- correct createSecret helper for string secrets


