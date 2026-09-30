# AGENTS.md

Rails + Ralix + Tailwind starter template. See [README.md](README.md) for the stack overview.

## This is a template

The code is meant to be **renamed and adapted** in each derived project, not used as-is:

- The app module is `RailsRalixTailwind` in [config/application.rb](config/application.rb). Rename it when adopting the template.
- `User` ([app/models/user.rb](app/models/user.rb)) is the only real model; the rest (`pages`, `errors`, `home`) are layout examples.
- When working in a derived project, prefer the conventions already present in that repo over the ones in this template.

## Commands

| Action | Command |
| --- | --- |
| Initial setup | `bin/setup` |
| Development | `bin/dev` (web + JS/CSS watchers, see [Procfile.dev](Procfile.dev)) |
| Build JS | `yarn build` |
| Build CSS | `yarn build:css` |
| Verify class loading | `bin/rails zeitwerk:check` |

There is no test suite. Before considering a task done, run `bin/rails zeitwerk:check`, `yarn build`, and `yarn build:css`. Any command that touches the database requires PostgreSQL running with the credentials from [config/database.yml](config/database.yml).

## Conventions

- `app/assets/builds/` is **generated**. Never edit it by hand; edit the sources in `app/javascript/` and `app/assets/stylesheets/`.
- CSS: Tailwind 3 with `@apply` in flat files under `app/assets/stylesheets/components/`, imported from [app/assets/stylesheets/application.css](app/assets/stylesheets/application.css). There is no SCSS.
- JS: Ralix with route-based controllers in [app/javascript/controllers/app.js](app/javascript/controllers/app.js) and components in `app/javascript/components/`.
- Ransack 4 requires an explicit allowlist: when exposing a model to search/sort, define `self.ransackable_attributes`.
- Devise views use `data: { turbo: "false" }` on their forms; keep it when adding authentication views.
- Versions are pinned to stable branches (Ruby in [.ruby-version](.ruby-version), gems in [Gemfile](Gemfile), packages in [package.json](package.json)). When updating, bump patches within the branch before jumping a major.

## Skills

Installed under `.agents/skills/` and tracked in [skills-lock.json](skills-lock.json) (managed with `npx skills add`). **They are a reference for the target project, not a description of this repo**: verify against the actual code before applying them.

| Skill | Use for | Caveat |
| --- | --- | --- |
| [rails-expert](.agents/skills/rails-expert/SKILL.md) | Active Record, Turbo Frames/Streams, Action Cable | Assumes RSpec and Sidekiq, which are **not** installed here |
| [ralix-rails](.agents/skills/ralix-rails/SKILL.md) | Ralix controllers, components, and helpers | Aligned with Ralix 1.9, the version used by the template |
| [scss-bem-styling](.agents/skills/scss-bem-styling/SKILL.md) | SCSS and BEM | The template uses Tailwind + plain CSS; apply only if the project migrates to SCSS |

If you adopt any of those tools (RSpec, Sidekiq, SCSS), add it to `Gemfile`/`package.json` and update this file.
