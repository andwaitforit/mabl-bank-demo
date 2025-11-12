# Scripts Directory

This directory contains all automation scripts for the Banking App demo, organized by purpose.

## 📁 Directory Structure

```
scripts/
├── demo/           # Demo feature management scripts
├── deployment/     # Git commit and deployment automation
├── testing/        # Test execution scripts
└── utils/          # Utility scripts (help, documentation)
```

## 🎭 Demo Scripts (`scripts/demo/`)

Scripts for managing the donation feature demo cycle:

| Script | Command | Description |
|--------|---------|-------------|
| `add-broken-feature.sh` | `npm run add-broken-feature` | Adds the donation feature with a bug |
| `fix-feature.sh` | `npm run fix-feature` | Fixes the donation feature bug |
| `reset-feature.sh` | `npm run reset-feature` | Resets to original state (no donation) |
| `demo-auto-healing.sh` | `npm run autoheal` | Auto-healing demo (mabl vs Playwright) |
| `demo-cycle.sh` | `npm run demo:cycle` | Interactive demo cycle manager |

### Demo Cycle Workflow

```bash
# 1. Add the feature
npm run add-broken-feature

# 2. (Optional) Fix the feature  
npm run fix-feature

# 3. Reset to original
npm run reset-feature
```

## 🚀 Deployment Scripts (`scripts/deployment/`)

Scripts for committing and deploying changes:

| Script | Command | Description |
|--------|---------|-------------|
| `commit-and-deploy.sh` | `npm run commit-and-deploy` | Commit changes and create release tag |
| `reset-and-commit.sh` | `npm run reset-and-commit` | Reset feature, commit, and optionally deploy |

### Deployment Workflow

```bash
# Commit and deploy with auto-versioning
npm run commit-and-deploy

# Or combine demo and deployment
npm run demo:add-and-deploy     # Add feature → commit → deploy
npm run demo:reset-and-deploy   # Reset feature → commit → deploy
```

### Version Tagging

Deployment scripts automatically:
- Detect the latest version tag (e.g., `v2.5-prod`)
- Suggest the next version (e.g., `v2.6-prod`)
- Create and push the tag to trigger CI/CD

Tags with `-prod` suffix trigger the full deployment pipeline including:
1. Build and push Docker images
2. Run mabl regression tests
3. Deploy to TrueNAS
4. Run mabl smoke tests

## 🧪 Testing Scripts (`scripts/testing/`)

Scripts for running various tests:

| Script | Command | Description |
|--------|---------|-------------|
| `test-api.js` | `npm run test:api` | Test backend API endpoints |
| `test-codex-mcp.sh` | `npm run test:codex-mcp` | Run codex MCP tests |

Additional test commands (defined in package.json):
- `npm run test:playwright` - Run all Playwright tests
- `npm run test:playwright:ui` - Run Playwright with UI
- `npm run test:donation` - Run donation feature tests

## 🛠️ Utils Scripts (`scripts/utils/`)

Utility and helper scripts:

| Script | Command | Description |
|--------|---------|-------------|
| `show-commands.sh` | `npm run help` | Display all available commands |

## 🔄 Complete Demo Cycle Example

For a full demonstration workflow:

```bash
# Interactive menu (recommended)
npm run demo:cycle

# Or manual steps:
npm run demo:add-and-deploy     # Add feature and deploy
# ... wait for deployment and run tests ...
npm run demo:reset-and-deploy   # Reset and deploy clean state
```

## 📝 Notes

- All scripts maintain backward compatibility through npm commands
- Scripts automatically handle git operations (add, commit, push, tag)
- Version numbering is auto-incremented based on existing tags
- All deployment tags follow the pattern `vX.Y-prod`

## 🔗 Related Documentation

- [NPM Scripts Reference](../docs/NPM_SCRIPTS_REFERENCE.md)
- [Donation Feature Demo](../docs/DONATION_FEATURE_DEMO.md)
- [Docker Testing](../docs/DOCKER_TESTING.md)
- [Deployment Guide](../DEPLOYMENT.md)

