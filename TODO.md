# TODO – Clay Feature Parity

This is an AI generated draft of what wouls require a feature parity with Clay.

## Core runtime & data model
- [ ] Design Ruby-facing DSL/macros that mirror Clay's declarative hierarchy (`CLAY`, `CLAY_TEXT`, component helpers).
- [ ] Implement internal element tree with layout/state structs comparable to `Clay_ElementDeclaration` and friends.
- [ ] Support deterministic element IDs (symbol/string based) plus local scoping helpers similar to `CLAY_ID*`.
- [ ] Provide lifecycle hooks to create/reset layout contexts (`Clay_Initialize`, `Clay_BeginLayout`/`EndLayout`, multiple instances).
- [ ] Allow layout tree reuse across frames (component caching, diffing, memoization toggles).

## Layout engine capabilities
- [ ] Implement flex-like sizing flags (fixed, grow, shrink, wrap) and layout directions (row/column).
- [ ] Add alignment controls (justify, align, gap) including padding/margin shorthand helpers.
- [ ] Support min/max constraints, aspect ratio, and baseline alignment parity.
- [ ] Implement floating/absolute positioning equivalent (`Clay_FloatingElementConfig`).
- [ ] Add visibility toggles and display-none style handling.
- [ ] Implement visibility culling to skip layout/rendering of off-screen elements.
- [ ] Provide custom element layout callbacks for user-defined sizing logic.
- [ ] Support nested clipping regions and clip-stack semantics.

## Text & measurement
- [ ] Expose text element API mirroring `CLAY_TEXT` with font sizing, wrapping, letter spacing.
- [ ] Implement pluggable text measurement callback and caching to avoid repeated width calculations.
- [ ] Handle unicode-aware truncation/wrapping rules required for TUIs.
- [ ] Surface APIs to tune cache sizes and reset measurement caches (`Clay_ResetMeasureTextCache` parity).

## Scroll & interaction
- [ ] Support scroll containers with momentum/offset tracking (`Clay_UpdateScrollContainers`, pointer state).
- [ ] Track pointer hover/focus data to enable `Clay_Hovered`/`OnHover` analogues in Ruby.
- [ ] Map keyboard/mouse/terminal events into pointer state updates for TUI environments.
- [ ] Provide APIs to query scroll offsets and pointer metadata.
- [ ] Handle pointer capture, drag gestures, and nested scroll wheel deltas.

## Rendering integration
- [ ] Define render command objects (rectangles, borders, text, clips) comparable to `Clay_RenderCommand`.
- [ ] Implement renderer bridge for Termbox2 (or other TUI backends), including clipping and layering.
- [ ] Support retained-mode render cache so layouts can reuse computed command buffers per frame.
- [ ] Provide hooks to stream render commands to alternate backends (Canvas, SDL, Web renderers).
- [ ] Implement draw-order sorting and z-index semantics consistent with Clay.

## Memory & performance
- [ ] Replace Clay arena allocator with Ruby-friendly pooling while keeping predictable allocations.
- [ ] Benchmark layout performance versus baseline Clay examples to validate parity.
- [ ] Add profiling hooks/metrics to surface node counts and layout timings.
- [ ] Expose configurable element/text limits (parity with `Clay_SetMaxElementCount`, `Clay_SetMaxMeasureTextCacheWordCount`).
- [ ] Offer optional arena-backed allocator path for embedding in C hosts.

## Tooling & debug
- [ ] Provide debug overlay/CLI tooling similar to Clay's inspector (element outline, layout data).
- [ ] Surface structured error messages mirroring `Clay_ErrorData`.
- [ ] Document configuration flags/macros (e.g., enabling assertions, max element count).
- [ ] Add runtime toggles for debug draws, layout dumps, and render command inspection.

## Ecosystem & docs
- [ ] Port representative Clay examples to mruby-panes demos (dashboard, settings pane, scroll lists).
- [ ] Write thorough README/API reference covering DSL, lifecycle, examples.
- [ ] Add automated tests mirroring Clay test coverage (layout snapshots, scroll behavior, text measurement).
- [ ] Package gem dependencies/build scripts so users can drop-in replacement for mruby-clay.
- [ ] Publish migration guide outlining Clay feature parity and trade-offs for mruby users.
