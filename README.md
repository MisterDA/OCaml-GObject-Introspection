[![Build Status](https://travis-ci.org/cedlemo/OCaml-GObject-Introspection.svg?branch=master)](https://travis-ci.org/cedlemo/OCaml-GObject-Introspection)
[![Build status](https://ci.appveyor.com/api/projects/status/jlsk9qhxffuq2h1y?svg=true)](https://ci.appveyor.com/project/cedlemo/ocaml-gobject-introspection)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)


# OCaml GObject-Introspection

The OCaml bindings to the GObject-Introspection library with Ctypes.

Two ideas to explore:

 - Create a generic Ctypes bindings generator, based on ocaml-gobject-introspection,
   for the GNOME libraries : https://github.com/cedlemo/OCaml-GI-ctypes-bindings-generator

 - Create a generic FFI bindings generator for bucklescript in order to be able to
  use the javascript bindings to the GNOME libraries. (I am not sure if it is faisable).

   - https://devdocs.baznga.org/
   - https://bucklescript.github.io/bucklescript/Manual.html#_ffi
   - https://github.com/glennsl/bucklescript-ffi-cheatsheet

## API:

https://cedlemo.github.io/OCaml-GObject-Introspection/

## Wiki :

https://github.com/cedlemo/OCaml-GObject-Introspection/wiki#introduction

###  table of content.

- [Introduction](https://github.com/cedlemo/OCaml-GObject-Introspection/wiki#introduction)
- [https://github.com/cedlemo/OCaml-GObject-Introspection/wiki#implementation-details)
  - [GObjectIntrospection Info Structures hierarchy and type coercion functions](https://github.com/cedlemo/OCaml-GObject-Introspection/wiki#gobjectintrospection-info-structures-hierarchy-and-type-coercion-functions)
  - [How the underlying C structures allocation and deallocation are handled](https://github.com/cedlemo/OCaml-GObject-Introspection/wiki#how-the-underlying-c-structures-allocation-and-deallocation-are-handled)
  - [Progress](https://github.com/cedlemo/OCaml-GObject-Introspection/wiki#progress)
    - [Finished](https://github.com/cedlemo/OCaml-GObject-Introspection/wiki/#finished)
    - [Remains](https://github.com/cedlemo/OCaml-GObject-Introspection/wiki/#remains)
  - [Resources](https://github.com/cedlemo/OCaml-GObject-Introspection/wiki/#resources)

