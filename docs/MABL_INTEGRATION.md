# mabl Integration Guide

This repository is integrated with [mabl](https://www.mabl.com/) for automated testing after Docker image deployments. The CI/CD pipeline automatically runs regression tests whenever a new Docker image is pushed to the GitHub Container Registry.

## Overview

After successfully building and pushing the Docker image, the GitHub Actions workflow automatically:
1. Creates a mabl deployment event
2. Triggers all tests with the `regression` label
3. Waits for test results
4. Reports pass/fail status

Based on the [mabl GitHub Actions documentation](https://github.com/mablhq/github-run-tests-action).

## Configuration

### Application & Environment

The workflow is configured to test against:
- **Application ID**: `DKjPLqbtZzGN9wuWe2Lylg-a`
- **Environment ID**: `eYHXwE5MYUVwMrsM1D8w0g-e`
- **Plan Labels**: `regression`

### When Tests Run

mabl tests are executed:
- ✅ On pushes to `main` branch (after Docker image is built)
- ✅ On version tags (e.g., `v1.0.0`)
- ✅ On manual workflow dispatch
- ❌ NOT on pull requests (to save testing resources)

## Setup Requirements

### 1. Create mabl API Key

1. Log in to your mabl account
2. Navigate to **Settings** → **APIs**
3. Create a new API key with type: **"CI/CD Integration"**
4. Copy the API key (you'll only see it once!)

### 2. Add API Key to GitHub Secrets

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `MABL_API_KEY`
5. Value: Paste your mabl API key
6. Click **Add secret**

### 3. Verify GitHub Token

The workflow uses `GITHUB_TOKEN` which is automatically available in GitHub Actions. No additional setup needed for this secret.

## Workflow Behavior

### Success Scenario

```
✓ Build Docker image
✓ Push to GHCR
✓ Run mabl tests
  → All regression tests pass
✓ Workflow succeeds
```

### Failure Scenario

```
✓ Build Docker image
✓ Push to GHCR
✓ Run mabl tests
  → Some tests fail
✗ Workflow fails (prevents bad deployments)
```

**Note**: The workflow is configured with `continue-on-failure: false`, meaning test failures will fail the entire workflow.

## Test Results

After each deployment, the workflow outputs:

```
mabl Deployment ID: <deployment-id>
Plans Run: 5
Plans Passed: 4
Plans Failed: 1
Tests Run: 23
Tests Passed: 21
Tests Failed: 2
```

### Viewing Detailed Results

1. Go to the **Actions** tab in GitHub
2. Click on the workflow run
3. Expand the **"Run mabl regression tests"** step
4. View the summary and click the mabl link for detailed results
5. Or go directly to [mabl app](https://app.mabl.com/) and view the deployment

## Customizing the Integration

### Run on Pull Requests

To enable testing on PRs, remove the `if` condition:

```yaml
- name: Run mabl regression tests
  id: mabl-test-deployment
  # Remove this line:
  # if: github.event_name != 'pull_request'
  uses: mablhq/github-run-tests-action@v1
```

### Continue on Test Failures

To allow deployments even when tests fail:

```yaml
with:
  application-id: DKjPLqbtZzGN9wuWe2Lylg-a
  environment-id: eYHXwE5MYUVwMrsM1D8w0g-e
  plan-labels: regression
  continue-on-failure: true  # ← Change to true
```

### Add Multiple Plan Labels

Test multiple plan labels (tests matching ANY label will run):

```yaml
with:
  application-id: DKjPLqbtZzGN9wuWe2Lylg-a
  environment-id: eYHXwE5MYUVwMrsM1D8w0g-e
  plan-labels: |
    regression
    smoke-test
    critical-path
```

### Specify Browsers

Override which browsers to test:

```yaml
with:
  application-id: DKjPLqbtZzGN9wuWe2Lylg-a
  environment-id: eYHXwE5MYUVwMrsM1D8w0g-e
  plan-labels: regression
  browser-types: |
    chrome
    firefox
    webkit
```

### Override Application URL

Test against a specific URL (useful for preview environments):

```yaml
with:
  application-id: DKjPLqbtZzGN9wuWe2Lylg-a
  environment-id: eYHXwE5MYUVwMrsM1D8w0g-e
  plan-labels: regression
  app-url: https://preview-branch.example.com
```

## Workflow Integration with Other Actions

You can use mabl test results in subsequent steps:

```yaml
- name: Run mabl regression tests
  id: mabl-test-deployment
  uses: mablhq/github-run-tests-action@v1
  env:
    MABL_API_KEY: ${{ secrets.MABL_API_KEY }}
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  with:
    application-id: DKjPLqbtZzGN9wuWe2Lylg-a
    environment-id: eYHXwE5MYUVwMrsM1D8w0g-e
    plan-labels: regression

- name: Notify Slack on failure
  if: failure()
  run: |
    echo "Tests failed: ${{ steps.mabl-test-deployment.outputs.tests_failed }}"
    # Add your Slack notification here
```

## GitHub App Integration (Optional)

For richer integration (PR comments, commit status checks, etc.):

1. Install the [mabl GitHub App](https://github.com/apps/mabl)
2. Grant access to your repository
3. mabl will automatically:
   - Comment on PRs with test results
   - Update commit statuses
   - Link deployments to GitHub commits

## Troubleshooting

### "Invalid API key" Error

- Verify the API key is correctly set in GitHub Secrets
- Ensure you created a **"CI/CD Integration"** type API key (not a personal API key)
- Check that the secret name is exactly `MABL_API_KEY`

### No Tests Run

- Verify tests exist in mabl with the `regression` label
- Check that tests are associated with the specified application/environment
- Ensure tests are enabled (not disabled in mabl)

### Workflow Times Out

- Check if tests are taking too long in mabl
- The action will wait for all tests to complete
- Consider splitting long test suites into multiple plans

### Tests Pass Locally but Fail in CI

- Verify the application URL is accessible from GitHub Actions runners
- Check if there are timing issues (may need to adjust waits in tests)
- Review mabl test logs for specific failures

## Best Practices

1. **Label Your Tests**: Use descriptive labels like `regression`, `smoke-test`, `critical-path` for better organization
2. **Fast Feedback**: Keep regression suites under 10 minutes for quick feedback
3. **Monitor Results**: Set up notifications for test failures
4. **Update Tests**: Keep mabl tests in sync with application changes
5. **Use Branches**: Create mabl test branches for feature development

## Resources

- [mabl Documentation](https://help.mabl.com/)
- [mabl GitHub Action](https://github.com/mablhq/github-run-tests-action)
- [mabl API Reference](https://help.mabl.com/docs/mabl-rest-api)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## Support

For issues with:
- **mabl tests**: Contact mabl support or check [mabl Help Center](https://help.mabl.com/)
- **GitHub Actions**: Check the Actions tab for error logs
- **This integration**: Open an issue in this repository

