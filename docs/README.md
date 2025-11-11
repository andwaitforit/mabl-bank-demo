# Documentation Index

This directory contains all documentation for the Banking App demo project.

## 📚 Quick Links

### Getting Started
- **[Setup Complete](SETUP_COMPLETE.md)** - Overview of npm scripts and what was added
- **[NPM Scripts Reference](NPM_SCRIPTS_REFERENCE.md)** - Complete command reference

### Demo Guides
- **[Donation Feature Demo](DONATION_FEATURE_DEMO.md)** - Pre-PR bug detection demo walkthrough
- **[Auto-Healing Demo](../README.md#1-auto-healing-demo-mabl-vs-playwright)** - mabl vs Playwright comparison

### Technical Documentation
- **[API Documentation](API_DOCUMENTATION.md)** - Backend API endpoints
- **[Docker Testing](DOCKER_TESTING.md)** - Docker deployment guide
- **[mabl Integration](MABL_INTEGRATION.md)** - Automated testing in CI/CD pipeline
- **[Alternative AI MCP Approach](ALTERNATIVE_AI_MCP_APPROACH.md)** - Alternative implementation
- **[Codex MCP Jenkins](CODEX_MCP_JENKINS.md)** - Jenkins integration

### Troubleshooting & Fixes
- **[Troubleshooting Donation Demo](TROUBLESHOOTING_DONATION_DEMO.md)** - Debug guide for donation feature
- **[Checkbox Fix Summary](CHECKBOX_FIX_SUMMARY.md)** - How the checkbox issue was fixed
- **[Donation Fix Explained](DONATION_FIX_EXPLAINED.md)** - Technical explanation of the donation bug
- **[Donation Feature V2 Changes](DONATION_FEATURE_V2_CHANGES.md)** - Changelog for fixed $5 donation
- **[Node Options Fix](NODE_OPTIONS_FIX.md)** - OpenSSL compatibility fix

---

## 📖 Documentation by Category

### 🎯 For Demos & Presentations

| Document | Purpose | Audience |
|----------|---------|----------|
| [Donation Feature Demo](DONATION_FEATURE_DEMO.md) | Complete walkthrough of bug detection demo | Sales, Training |
| [Setup Complete](SETUP_COMPLETE.md) | Quick overview of all features | New users |
| [NPM Scripts Reference](NPM_SCRIPTS_REFERENCE.md) | Command cheat sheet | Developers |

### 🔧 For Development

| Document | Purpose | Audience |
|----------|---------|----------|
| [API Documentation](API_DOCUMENTATION.md) | Backend API reference | Developers |
| [Docker Testing](DOCKER_TESTING.md) | Docker setup and testing | DevOps |
| [GitHub Container Registry](GITHUB_CONTAINER_REGISTRY.md) | GHCR setup and usage | DevOps |
| [mabl Integration](MABL_INTEGRATION.md) | Automated testing in CI/CD | DevOps, QA |
| [Codex MCP Jenkins](CODEX_MCP_JENKINS.md) | CI/CD integration | DevOps |

### 🐛 For Debugging

| Document | Purpose | Audience |
|----------|---------|----------|
| [Troubleshooting Donation Demo](TROUBLESHOOTING_DONATION_DEMO.md) | Comprehensive debug guide | Support, QA |
| [Checkbox Fix Summary](CHECKBOX_FIX_SUMMARY.md) | Checkbox toggle issue | Developers |
| [Donation Fix Explained](DONATION_FIX_EXPLAINED.md) | Technical bug analysis | Developers |

### 📝 Reference & History

| Document | Purpose | Audience |
|----------|---------|----------|
| [Donation Feature V2 Changes](DONATION_FEATURE_V2_CHANGES.md) | Version 2 changelog | All |
| [Node Options Fix](NODE_OPTIONS_FIX.md) | OpenSSL compatibility | Developers |
| [Alternative AI MCP Approach](ALTERNATIVE_AI_MCP_APPROACH.md) | Alternative implementation | Architects |

---

## 🚀 Common Scenarios

### "I want to run a demo"
1. Start with: [Setup Complete](SETUP_COMPLETE.md)
2. Then: [Donation Feature Demo](DONATION_FEATURE_DEMO.md)
3. Reference: [NPM Scripts Reference](NPM_SCRIPTS_REFERENCE.md)

### "Something isn't working"
1. Check: [Troubleshooting Donation Demo](TROUBLESHOOTING_DONATION_DEMO.md)
2. Review: [Checkbox Fix Summary](CHECKBOX_FIX_SUMMARY.md)
3. Debug: Run `npm run help`

### "I need to understand the code"
1. Read: [Donation Fix Explained](DONATION_FIX_EXPLAINED.md)
2. Review: [Donation Feature V2 Changes](DONATION_FEATURE_V2_CHANGES.md)
3. Check: [API Documentation](API_DOCUMENTATION.md)

### "I'm setting up Docker"
1. Follow: [Docker Testing](DOCKER_TESTING.md)
2. Reference: [API Documentation](API_DOCUMENTATION.md)
3. Use: `npm run docker:up`

---

## 📦 File Organization

```
docs/
├── README.md                              # This file - documentation index
│
├── Getting Started/
│   ├── SETUP_COMPLETE.md                  # Initial setup overview
│   └── NPM_SCRIPTS_REFERENCE.md           # Command reference
│
├── Demo Guides/
│   └── DONATION_FEATURE_DEMO.md           # Main demo walkthrough
│
├── Technical/
│   ├── API_DOCUMENTATION.md               # API endpoints
│   ├── DOCKER_TESTING.md                  # Docker guide
│   ├── CODEX_MCP_JENKINS.md              # Jenkins integration
│   └── ALTERNATIVE_AI_MCP_APPROACH.md     # Alternative approach
│
└── Troubleshooting/
    ├── TROUBLESHOOTING_DONATION_DEMO.md   # Debug guide
    ├── CHECKBOX_FIX_SUMMARY.md            # Checkbox fix
    ├── DONATION_FIX_EXPLAINED.md          # Technical explanation
    ├── DONATION_FEATURE_V2_CHANGES.md     # Version 2 changelog
    └── NODE_OPTIONS_FIX.md                # OpenSSL fix
```

---

## 🔗 External Links

- **Main README**: [../README.md](../README.md)
- **Package Scripts**: [../package.json](../package.json)
- **Test Scripts**: [../tests/](../tests/)
- **Demo Scripts**: Root directory (*.sh files)

---

## ✨ Quick Commands

```bash
# View all available commands
npm run help

# Run complete donation demo
npm run demo:full

# View this documentation
cat docs/README.md
```

---

**Last Updated**: November 2025

