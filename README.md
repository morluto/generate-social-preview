# Generate Social Preview

A reusable agent skill for creating social preview images grounded in what a
repository actually does. It reads the project, shapes concise copy, and
produces a card that stays readable at thumbnail size.

Use it for GitHub repository previews, package pages, launch posts, and link
cards for skills, libraries, developer tools, SaaS products, and other projects.
It supports new images, revisions, palette variants, and adapting a supplied
style reference.

## Install

Install for Cursor, Claude Code, Codex, GitHub Copilot, Gemini CLI, Cline,
Windsurf, Amp, and other supported agents with the
[Skills CLI](https://github.com/vercel-labs/skills):

```bash
npx skills add morluto/generate-social-preview
```

In Claude Code, you can use the plugin marketplace for the skill's slash
command and update management:

```text
/plugin marketplace add morluto/generate-social-preview
/plugin install generate-social-preview@generate-social-preview
```

After installation, invoke `/generate-social-preview:generate-social-preview`.
For automatic updates, open `/plugin`, select the marketplace under
**Marketplaces**, and choose **Enable auto-update**. Choose one installation
method per agent to avoid duplicate copies.

The Skills CLI requires Node.js and npm. Select your agent in the installer,
or pass `--agent claude-code`, for example. Add `--global` for a user-wide
installation.

In Codex, install through its native plugin marketplace:

```bash
codex features enable plugins
codex plugin marketplace add morluto/generate-social-preview
codex plugin add generate-social-preview@generate-social-preview
```

Start a new Codex session after installation and invoke
`$generate-social-preview:generate-social-preview`.

## Image tools

Use whatever image-generation and editing tools are available in your agent.
The skill works with the host's tools, APIs, CLIs, or installed image skills.
Use image viewing to inspect references and results. If generation is
unavailable, the agent can still prepare the copy, reference choices, and a
generation prompt.

The optional normalization helper needs Bash and either macOS `sips` or
ImageMagick (`magick` in version 7, or `convert` in version 6).

## Use

Open the repository you want to feature and ask your agent:

```text
Use the generate-social-preview skill to create a GitHub social preview for this repository.
```

You can provide a direction or constrain a revision:

```text
Use the generate-social-preview skill with a Swiss technical direction and a warm paper palette.
```

```text
Use the generate-social-preview skill to revise this card. Change only the tagline;
keep the product name, palette, and illustration unchanged.
```

By default, the skill produces one candidate, checks the copy and composition,
and saves a versioned image without overwriting an existing asset. GitHub
previews are normalized to a 1280×640 PNG after visual inspection.

## How it uses project references

Ground the imagery in the project, then choose the composition.

1. **Find relevant material.** Follow image links in the README and docs, and
   inspect screenshots, illustrations, demos, example outputs, and brand assets
   in the repository.
2. **Use what fits.** Pass useful images to the generator as project references,
   drawing on recognizable details, outputs, or brand cues. Existing material
   earns its place by helping communicate the project.
3. **Develop an idea when needed.** If existing images do not fit, build a visual
   idea from the project's purpose, examples, or domain. A skill, library, and
   SaaS product may each call for a different approach.

Project references inform what the preview shows; style references inform how
it looks. The composition can be a single image, typography, an interface, or
a sequence when the steps help explain the project.

## Visual directions

The bundled [style guide](skills/generate-social-preview/references/style-directions.md) offers retro
editorial, Swiss technical, terminal collage, and diagrammatic print as
starting points. Choose what best communicates the project: typography, a
symbol, an illustration, an interface, an output, or a sequence when useful.

These are [examples from specific projects](skills/generate-social-preview/references/examples.md):

| Open SaaS: retro editorial | REA: analysis artifacts and a sequence |
| --- | --- |
| ![Flat color blocks and pixel typography](skills/generate-social-preview/assets/style-references/retro-editorial.png) | ![Command, inspection views, and an ordered workflow](skills/generate-social-preview/assets/style-references/evidence-workflow.png) |

Credit to [Vince Canger (@vincanger)](https://github.com/vincanger) for the
Open SaaS artwork used as the retro editorial reference, shared in his original
post, [How I promoted my open source repo to 6k stars in 6 months](https://dev.to/wasp/how-i-promoted-my-open-source-repo-to-6k-stars-in-6-months-3li9).

The second reference was used for [REA](https://github.com/morluto/rea).
Its workflow composition fits that example; each project's preview should
use the composition that serves its own message.

## Normalize an existing image

```bash
bash path/to/generate-social-preview/scripts/normalize-preview.sh \
  candidate.png social-preview-v1.png
```

Replace `path/to/generate-social-preview` with the installed skill directory
(`skills/generate-social-preview/` in this repository).
The helper accepts an approximately 2:1 source, writes a 1280×640 PNG, and
refuses to overwrite an existing output. It does not generate images or check
their visual quality.

## Repository contents

- [SKILL.md](skills/generate-social-preview/SKILL.md) — workflow, copy guidance, and visual checks.
- `.claude-plugin/` — Claude Code plugin and marketplace manifests.
- `.codex-plugin/` — Codex plugin manifest.
- `.agents/plugins/marketplace.json` — Codex marketplace catalog.
- [agents/openai.yaml](skills/generate-social-preview/agents/openai.yaml) — optional Codex display metadata.
- [references/style-directions.md](skills/generate-social-preview/references/style-directions.md) — art direction guidance.
- [references/examples.md](skills/generate-social-preview/references/examples.md) — project examples and attribution.
- `skills/generate-social-preview/assets/style-references/` — labeled visual references.
- [scripts/normalize-preview.sh](skills/generate-social-preview/scripts/normalize-preview.sh) — image normalization helper.
