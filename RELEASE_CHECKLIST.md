# Release Checklist

Use this checklist for every release to keep the process consistent.

- [ ] **Update CHANGELOG.md**
  - Add a new `[x.y.z]` section at the top
  - Use today's date for `- YYYY-MM-DD`
  - List all changes under `Added`, `Changed`, `Fixed`, or `Removed`

- [ ] **Update version references**
  - Bump `version` in `pubspec.yaml`
  - Update example app's dependency if needed

- [ ] **Run tests + lint**
  ```bash
  flutter test
  flutter analyze
  ```

- [ ] **Ensure README.md is up-to-date**
  - Review installation instructions
  - Confirm widget docs links are correct

- [ ] **Merge to main**
  - Open PR and get review
  - Merge to `main` branch

- [ ] **Tag + create GitHub Release**
  - Create tag: `git tag v1.0.0`
  - Push tag: `git push origin v1.0.0`
  - Create GitHub Release
    - **Title:** `v1.0.0 — Initial release` (or copy from CHANGELOG)
    - **Description:** Copy release notes from CHANGELOG
