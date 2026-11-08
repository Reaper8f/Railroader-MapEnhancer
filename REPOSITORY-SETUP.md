# Repository setup checklist

This file is an initialization guide. You can delete it after setup.

## 1. Create the GitHub repository [x]

Suggested repository name: `railroader-mapenhancer`

- Owner: `Reaper8f`
- Visibility: Public
- Initialize with README: No (this template already contains one)
- Add a license: No, until the maintainer has decided what terms apply to the contents of this hub.

## 2. Initialize this directory [x]

Run these commands from the local `distribution` directory:

```powershell
git init
git branch -M main
git add .
git commit -m "Initialise public Map Enhancer project hub"
git remote add origin https://github.com/Reaper8f/railroader-mapenhancer.git
git push -u origin main
```

If the GitHub repository name or owner differs, update the remote URL.

## 3. Configure GitHub

- Enable Issues.
- Enable Discussions and create categories such as Announcements, General, Ideas, and Q&A.
- Create a GitHub Project using `project-management/PROJECT_BOARD.md`.
- Add labels from `project-management/LABELS.md`.
- Enable private vulnerability reporting if available.
- Add the official website URL to the repository About section and README.
- Add release assets through GitHub Releases.

## 4. Keep the parent repository separate

The intended local layout is:

```text
railroader-mapenhancer2.0/       # Existing private main repository
├── website/                     # Separate website repository
└── distribution/                # This separate public repository hub
```

The `distribution` directory has its own `.git` directory. It is already excluded in the parent repository's `.gitignore`:

```gitignore
/website/
/distribution/
```

Check `git status` from the parent directory after making this change. Do not run `git add .` from the parent repository until you have confirmed the nested directories are excluded.

## 5. Before publishing content

- Replace placeholders with verified project information.
- Confirm the public licensing and redistribution policy.
- Confirm every release asset is approved for public distribution.
- Review content and Git history for credentials, private URLs, personal data, and internal notes.
- Never commit `.env` files, API tokens, Cloudflare credentials, database contents, or Worker secrets.

## Important

This template does not create a Git repository, configure GitHub settings, publish releases, or change the visibility of your existing repositories. It only provides files to initialize the new public hub.
