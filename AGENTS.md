# Repository Guidelines

## Project Structure & Module Organization
The mrbgem’s Ruby DSL (`Panes::Layout`, `Node`, text helpers) lives in `mrblib/`, while `src/` contains the small native extension that plugs into mruby. Vendored upstream sources reside in `mruby/`; avoid editing them directly unless you intend to run `bin/sync`. Examples for manual inspection sit in `examples/`, and automated specs are under `test/`, grouped by layout concern (`test/layout`, `test/calculations`, `test/text`).

## Build, Test, and Development Commands
Use the thin wrappers in `bin/` so the correct configuration is picked up:

```sh
bin/build                     # Compile mruby using build_config.rb
bin/build clean all           # Remove artifacts and rebuild
bin/run examples/layout.rb    # Run an example script through mruby
bin/test test/layout/complex.rb   # Execute a targeted spec file
rake mtest                    # Run the full mruby suite after building
```

## Coding Style & Naming Conventions
Ruby files use two-space indentation, snake_case names, and predicate helpers ending in `?` (e.g., `text?`). Favor keyword arguments for sizing, reuse shared modules (`SizingHelpers`, `DirectionHelpers`), and keep method bodies small—delegate to `Calculations` or `Padding` when possible. Strings default to single quotes unless interpolation is needed. Native code mirrors mruby’s conventions: lowercase_with_underscores symbols, braces on the same line, explicit `mrb_state*` parameters, and consistent error handling.

## Testing Guidelines
Add or update specs in the closest `test/` subfolder (layout behavior lives beneath `test/layout`, calculations beneath `test/calculations`, etc.). Keep filenames descriptive of the scenario (`test/layout/text/inline.rb`). Use `bin/test path/to/file.rb` during development and `rake mtest` before submitting to confirm the embedded mruby build still passes. Tests should cover min/max/grow sizing plus nested containers, since regressions often appear in those code paths. Shared helpers belong in `test/support.rb`.

## Commit & Pull Request Guidelines
Commits stay short, imperative, and scoped (recent history includes `Do not allocate a new array…` and `[DEPS] Update dependencies`). Use bracketed prefixes when touching vendored dependencies or tooling. Pull requests must describe the motivation, list functional changes, mention new commands or env vars, and link to any issue. Include screenshots or terminal captures when the rendered layout output differs, so reviewers can verify the behavior without rebuilding immediately.

## Configuration & Troubleshooting
On macOS, silence `malloc` warnings by exporting `MallocNanoZone=0` before running builds or tests. When the `mruby/` submodule needs a refresh, use `bin/sync` to pull, update recursively, and stage the resulting `[DEPS]` commit in one go. Document any additional environment flags in `README.md` so the next maintainer can reproduce your setup without guesswork.
