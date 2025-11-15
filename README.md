# mruby-panes

An mruby layout alternative to Clay dedicated to TUIs

**warning:** This mruby-gem is an experiment at this point and you might be better of using [mruby-clay](https://github.com/AlexB52/mruby-clay) if you want a layout library.

## Motivation

It felt less work to reimplement the basic features of Clay than extending the current library. lol

* I might not need the same performance for TUI layout.
* There are a couple things that the layout library assume that isn't completely true: text and borders can have a background.
* The feature requets for a grid and inline wrapper have been held up for a while now and Nick suggest to try it anyway in his [video](https://www.youtube.com/watch?v=by9lQvpvMIc).

## Grid layout

Use the `grid` helper inside any `ui` block to divide a container into rows and columns, then declare `area` blocks to place children into specific cells or spans.

```ruby
commands = layout.build(id: 'root', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
  ui(id: 'main', width: Panes::Sizing.grow, height: Panes::Sizing.grow) do
    grid columns: '20 1fr 2fr', rows: '3 1fr 3', gap: 1 do
      area :header, row: 1, col: :all do
        text 'Header'
      end

      area :sidebar, row: 2, col: 1 do
        text 'Sidebar'
      end

      area :content, row: 2, col: 2..3 do
        text 'Main content'
      end

      area :footer, row: 3, col: :all do
        text 'Footer'
      end
    end
  end
end
```

Tracks are defined by a single space-delimited string. Tokens accept fixed sizes (`'12'`), percentages of the container (`'30%'`), or fractional units (`'1fr'`, `'2fr'`) that share whatever space remains after fixed and percent tracks plus the configured gap. Areas may target a single row/column, a range (`row: 2..4`), or use `:all` to span the full axis. Nested grids work naturally because each `area` behaves like a regular `ui` node once its rectangle is computed.

Run `bin/run examples/grid.rb` to see the interactive demo that renders a header, sidebar, nested content grid, and footer using the DSL above.

## Build

Building mruby with mruby clay. The command is a wrapper of the Rake tasks located in mrucy folder.

      bin/build
      bin/build clean all # for a complete fresh build

## Test

After a building successfully mruby with mruby-clay

    rake mtest

## Troubleshooting

To remove the error message `mirb(19106,0x7ff85a248bc0) malloc: nano zone abandoned due to inability to reserve vm space.`

    export MallocNanoZone=0 