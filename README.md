# FlatRun Templates

The application template catalog for [FlatRun](https://github.com/flatrun/agent). Each
directory here is one deployable app that FlatRun turns into a running deployment.

## Available templates

| Template | ID | Category | Description |
|----------|-----|----------|-------------|
| Static Site | `static` | basic | Simple static HTML/CSS/JS site |
| WordPress | `wordpress` | application | Popular content management system |
| Nextcloud | `nextcloud` | application | Self-hosted productivity platform |
| Laravel | `laravel` | framework | PHP framework for web artisans |
| Ghost | `ghost` | application | Professional publishing platform |
| MinIO | `minio` | storage | S3-compatible object storage you host yourself |
| Next.js | `nextjs` | framework | React framework for production |
| Astro | `astro` | framework | The web framework for content-driven websites |
| Node.js | `node` | runtime | JavaScript runtime for web applications |
| PHP | `php` | runtime | PHP with Apache web server |
| Trakli | `trakli` | application | Personal finance tracker for wallets, transactions and budgets |
| SourceAnt | `sourceant` | application | AI pull request review and persistent memory for coding agents |

## Layout

One directory per template, at the repository root. The directory name is the template id:

```
<template-id>/
  docker-compose.yml   # required
  metadata.yml         # optional but recommended
  logo.svg             # optional, when metadata.yml names it as the logo
```

A directory is treated as a template only if it contains a `docker-compose.yml`.

## Adding a template

1. Create a directory named for the template id (lowercase, e.g. `redis-commander`).
2. Add a `docker-compose.yml` following the conventions below.
3. Add a `metadata.yml` so it shows up well in the catalog.
4. Open a pull request.

### docker-compose.yml

Standard Docker Compose, with FlatRun conventions:

- `name: ${NAME}` and `container_name: ${NAME}`: FlatRun substitutes the deployment name.
- `${PROXY_NETWORK}`: substituted with the proxy network name.
- Use `expose:`, not `ports:`. Apps are reached through the FlatRun reverse proxy, not by
  publishing host ports.
- Attach to the external proxy network:

  ```yaml
  networks:
    proxy:
      external: true
  ```

- Bind mounts only (`./data:/var/lib/data`), never named volumes, so all state stays in the
  deployment directory as flat files.

### metadata.yml

Describes the template to the UI and the deploy flow. Fields used across the current
templates:

| Field | Purpose |
|-------|---------|
| `name`, `description` | Display name and summary |
| `logo` | Brand logo: a [Simple Icons](https://simpleicons.org) link (`https://cdn.simpleicons.org/<slug>`), or the name of a PNG, WebP or SVG file in the template's directory (`logo.svg`), at most 512 KB, for an app Simple Icons does not carry. A project created from the template gets a copy. |
| `category` | Grouping: `application`, `framework`, `runtime`, `database`, `storage`, `basic` |
| `priority` | Sort order in the catalog (higher first) |
| `container_port` | Port the app listens on behind the proxy |
| `mounts` | Bind mounts offered at deploy time (`id`, `name`, `container_path`, `type`, `required`, `user`) |
| `files` | Files written into the deployment on create, with inline `content` (supports `${NAME}`) |
| `backup` | What a backup captures: `container_paths`, `databases`, and optional `pre_hooks` / `post_hooks` |

See `wordpress/metadata.yml` for a full example with mounts and a backup manifest, and
`static/metadata.yml` for the inline-`files` pattern.

## License

MIT. See [LICENSE](LICENSE).
