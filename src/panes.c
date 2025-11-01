#include <mruby.h>
#include <mruby/compile.h>

void mrb_mruby_panes_gem_init(mrb_state* mrb) {
  struct RClass* module = mrb_define_module(mrb, "Panes");
}

void mrb_mruby_panes_gem_final(mrb_state* mrb) {}