# headplane

[![CI](https://github.com/kgrubb/headplane-helm-chart/actions/workflows/ci.yml/badge.svg)](https://github.com/kgrubb/headplane-helm-chart/actions/workflows/ci.yml)

Helm chart for [Headplane](https://headplane.net), the web UI for
[Headscale](https://headscale.net).

There is no official upstream chart yet.

## Install

```bash
helm repo add kgrubb-headplane https://kgrubb.github.io/headplane-helm-chart
helm repo update
helm install headplane kgrubb-headplane/headplane -n headscale \
  --set fullnameOverride=headplane \
  --set secrets.existingSecret=headplane \
  --set config.server.baseUrl=https://headscale.example.org
```

Chart index: https://kgrubb.github.io/headplane-helm-chart/

Published charts are signed with the [public key](https://kgrubb.github.io/headplane-helm-chart/public.key) on gh-pages when `GPG_PRIVATE_KEY` is configured.

## Typical reverse proxy layout

Serve Headplane under `/admin` on the same host as Headscale (Tailscale-style):

```yaml
fullnameOverride: headplane
config:
  server:
    baseUrl: https://headscale.example.org
  headscale:
    url: http://headscale.headscale.svc.cluster.local:8080
    publicUrl: https://headscale.example.org
  oidc:
    enabled: true
    issuer: https://login.example.org/application/o/headplane/
    clientId: headplane
    defaultRole: owner
secrets:
  existingSecret: headplane
headscaleConfig:
  existingConfigMap: headscale
ingress:
  enabled: true
  className: traefik
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-cluster-issuer
    traefik.ingress.kubernetes.io/router.priority: "100"
  hosts:
    - host: headscale.example.org
      paths:
        - path: /admin
          pathType: Prefix
  tls:
    - secretName: headscale-tls
      hosts:
        - headscale.example.org
persistence:
  storageClass: longhorn
  size: 1Gi
```

`secrets.existingSecret` must provide `cookieSecret` (32 chars), `apiKey`
(`headscale apikeys create`), and `clientSecret` when OIDC is enabled.

## Development

```bash
helm lint charts/headplane --strict -f ci/values.yaml
helm template test charts/headplane -f ci/values.yaml
```
