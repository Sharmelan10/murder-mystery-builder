# Murder Mystery Builder — a Claude skill

A [Claude skill](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview) that writes a complete, **solvable** murder mystery for 1–2 players, then packages it as a game you can play without anyone spoiling it, including the person who asked Claude to build it.

It was built for date nights: you ask Claude for a case, you get back a game page with three sealed envelopes, and you play it together with no game master. It works just as well for friends, or for one person who likes a puzzle.

▶ **Try the demo:** download [`docs/demo.html`](docs/demo.html) and open it in a browser. It's a 20-minute, difficulty-1 case built with the bundled engine. (If you turn on GitHub Pages for the `docs/` folder, it's playable at `https://Sharmelan10.github.io/murder-mystery-builder/demo.html`.)

---

## What you get

When you ask Claude for a mystery, the skill makes Claude:

1. **Ask one round of questions:** theme or era, difficulty (1–3), tone, format, investigator names and any in-jokes.
2. **Write the truth first, then work backwards:** the killer, the motive, a minute-by-minute timeline, five suspects with secrets and alibis, witnesses, a map, and clues for motive, means and opportunity. Every innocent suspect gets a red herring *and* a way for the players to clear them.
3. **Run a QA gate before delivery:**
   - **Continuity:** a fact ledger checks every sentence against the timeline.
   - **Grammar and style:** one canonical name for every door and object, and one time format.
   - **Fairness:** a *blind solve*, where a fresh subagent sees only what the players see and must be able to solve the case at the right envelope.
   - **Technical:** a spoiler-leak scan and a headless click-through.
4. **Keep it spoiler-free:** the killer and the method never appear in chat, titles or file names, and the envelopes are scrambled inside the page.

### Output formats

| Format | What you get |
|---|---|
| **Online page** (default) | An interactive page with ticket-style tabs, a two-step "Break the seal" on each envelope, notes saved in the browser, an accusation form that unlocks the solution and checks your answer automatically, light and dark themes, and a reset button. |
| **Offline zip** | The same page as one HTML file plus `START HERE - How to play.txt`. |
| **Print** | Numbered PDFs: a briefing, three envelopes each with a "DO NOT READ" cover, and the solution. |

A full game takes about 90–120 minutes: a briefing, then three envelopes (the scene, statements and papers, the twist), then the accusation and the reveal.

---

## Install

### Option A: Claude apps (claude.ai, desktop, Cowork)

1. Download **`murder-mystery-builder.zip`** from this repo's [Releases](../../releases) page (or from [`dist/`](dist/)).
   *Don't unzip it. Upload the zip as it is.*
2. Make sure code execution is on. On Free, Pro and Max plans, go to **Settings → Capabilities** and turn on **Code execution and file creation**. On Team and Enterprise plans, your organisation owner controls this.
3. Go to **Customize → Skills**, click **+**, then **+ Create skill**, then **Upload a skill**, and choose the zip.
4. Make sure the skill is toggled on.

Menu names can change. If yours look different, see Anthropic's guide: [Use skills in Claude](https://support.claude.com/en/articles/12512180-use-skills-in-claude).

### Option B: Claude Code

```bash
# Personal install (all projects)
git clone https://github.com/Sharmelan10/murder-mystery-builder.git
mkdir -p ~/.claude/skills
cp -r murder-mystery-builder/murder-mystery-builder ~/.claude/skills/

# Or from the release zip
unzip murder-mystery-builder.zip -d ~/.claude/skills/
```

For one project only, copy the folder into `.claude/skills/` in that project instead. Restart Claude Code, then check that `murder-mystery-builder` appears when you ask *"What skills do you have?"*

### Option C: Claude API (Agent Skills)

Upload the `murder-mystery-builder/` folder as a custom skill with the Skills API. See [Using Agent Skills with the API](https://docs.claude.com/en/api/skills-guide).

---

## Use it

Just ask, for example:

> Make us a murder mystery for Friday. 1920s country house, difficulty 2, cosy but clever. We're Inspector Ada and Inspector Sam. Online page, please.

Claude will ask for anything that's missing, warn you not to expand its working steps (the solution is in them), build and check the case, and hand you the game.

**Tips**

- **Don't peek.** If you're one of the players, don't expand Claude's tool calls or open the scratch files while it builds.
- **Two screens?** Share the published page with your partner, or play on one screen together.
- **Keep a case log.** If you keep a `murder-mystery-cases.md` in a Claude Project or a connected folder, the skill reads it so it doesn't repeat past victims, methods or twists, and adds a spoiler-free row for each new case.
- **Give feedback afterwards.** The skill asks how the game went and can propose improvements to itself.

---

## Repo layout

```
murder-mystery-builder/          ← the skill (this folder is what gets installed)
├── SKILL.md                     ← instructions Claude follows
├── LICENSE.txt
├── scripts/engine.py            ← builds the game page from a case folder (standard-library Python)
├── assets/case.example.json     ← template case config
└── examples/demo-case/          ← a tiny complete case for testing
dist/murder-mystery-builder.zip  ← ready-to-upload skill package
docs/demo.html                   ← the demo case, built and playable
tests/smoke_test.py              ← builds the demo and checks it
package.sh                       ← rebuilds the zip
```

### The engine on its own

You can use the engine without Claude if you want to write a case by hand:

```bash
python3 murder-mystery-builder/scripts/engine.py path/to/my-case/
# writes my-case/standalone.html (play offline) and my-case/artifact.html (for hosts that wrap pages)
```

A case folder holds `case.json`, `briefing.html`, `e1.html`, `e2.html`, `e3.html` and `solution.html`. Copy `examples/demo-case/` to see the expected format. Envelopes and the solution are XOR-scrambled and base64-encoded in the page, so the plot can't be read by skimming the source. This is a guard against accidental spoilers, not encryption.

Requirements: Python 3.8+. Node.js and Playwright are optional and only used by the tests.

---

## Development

```bash
python3 tests/smoke_test.py   # build the demo case, check for spoiler leaks, JS syntax and a 400px click-through
./package.sh                  # rebuild dist/murder-mystery-builder.zip
```

The smoke test skips the JS and browser checks if Node.js or Playwright aren't installed.

To publish a release, run `./package.sh`, create a GitHub Release, and attach `dist/murder-mystery-builder.zip`:

```bash
gh release create v1.0.0 dist/murder-mystery-builder.zip --title "v1.0.0" --notes "First public release"
```

---

## Changelog

- **v1.0.0 (October 2026):** first public release. Built from three real date-night cases, with a QA gate added after playtest feedback.

## Licence

[MIT](LICENSE). Use it, adapt it, and make better mysteries.

*Not affiliated with Anthropic. "Claude" is a trademark of Anthropic.*
