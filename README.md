# mruby-panes

An mruby layout alternative to Clay dedicated to TUIs

**warning:** This mruby-gem is an experiment at this point and you might be better of using [mruby-clay](https://github.com/AlexB52/mruby-clay) if you want a layout library.

## Motivation

It felt less work to reimplement the basic features of Clay than extending the current library. lol

* I might not need the same performance for TUI layout.
* There are a couple things that the layout library assume that isn't completely true: text and borders can have a background.
* The feature requets for a grid and inline wrapper have been held up for a while now and Nick suggest to try it anyway in his [video](https://www.youtube.com/watch?v=by9lQvpvMIc). 

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