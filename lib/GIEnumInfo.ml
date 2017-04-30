(*
 * Copyright 2017 Cedric LE MOIGNE, cedlemo@gmx.com
 * This file is part of OCaml-GObject-Introspection.
 *
 * OCaml-GObject-Introspection is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * OCaml-GObject-Introspection is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OCaml-GObject-Introspection.  If not, see <http://www.gnu.org/licenses/>.
 *)

open Ctypes
open Foreign
open Conversions

type t
let enuminfo : t structure typ = structure "GIUnionInfo"

let get_n_values =
  foreign "g_enum_info_get_n_values"
    (ptr enuminfo @-> returning int)

let get_n_methods =
  foreign "g_enum_info_get_n_methods"
    (ptr enuminfo @-> returning int)

let get_method info n =
  let get_method_raw =
    foreign "g_enum_info_get_method"
      (ptr enuminfo @-> int @-> returning (ptr GIFunctionInfo.functioninfo)) in
  let max = get_n_methods info in
  if (n < 0 || n >= max) then raise (Failure "Array Index out of bounds")
  else let info' = get_method_raw info n in
    GIFunctionInfo.add_unref_finaliser_to_function_info info'

(* TODO : check that the info can be casted to a enuminfo ? *)
let cast_baseinfo_to_enuminfo info =
  coerce (ptr GIBaseInfo.baseinfo) (ptr enuminfo) info

let cast_enuminfo_to_baseinfo info =
  coerce (ptr enuminfo) (ptr GIBaseInfo.baseinfo) info

let enuminfo_of_baseinfo info =
  let _ = GIBaseInfo.base_info_ref info in
  let info' = cast_baseinfo_to_enuminfo info in
  let _ = Gc.finalise (fun i ->
      let i' = cast_enuminfo_to_baseinfo i in
      GIBaseInfo.base_info_unref i') info' in
  info'

let baseinfo_of_enuminfo info =
  let info' = cast_enuminfo_to_baseinfo info in
  let _ = GIBaseInfo.base_info_ref info' in
  let _ = Gc.finalise (fun i ->
      GIBaseInfo.base_info_unref i) info' in
  info'

