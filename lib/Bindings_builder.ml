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

open BuilderUtils

type file = {
  name: string;
  descr : Pervasives.out_channel;
}

type files = {
  ml : file;
  mli : file;
}

let file_in_create_append_mode name =
  Pervasives.open_out_gen [Open_trunc; Open_append; Open_creat] 0o666 name

let generate_sources base_name =
  let name = base_name ^ ".ml" in
  let descr = file_in_create_append_mode name in
  let ml = {name; descr} in
  let name = base_name ^ ".mli" in
  let descr = file_in_create_append_mode name in
  let mli = {name; descr} in
  {ml; mli}

let close_sources source_files =
  let close_file f =
    if Sys.file_exists f.name then Pervasives.close_out f.descr in
  close_file source_files.ml;
  close_file source_files.mli

let append_open_ctypes_modules (mli_descr, ml_descr) =
  add_open_ctypes mli_descr;
  add_open_ctypes ml_descr;
  add_open_foreign ml_descr;
  add_empty_line mli_descr;
  add_empty_line ml_descr

let generate_ctypes_sources base_name =
  let sources = generate_sources base_name in
  let _ = append_open_ctypes_modules (sources.mli.descr, sources.ml.descr) in
  sources

let parse_invalid_info info =
  ()

let parse_function_info info source_files =
  match Base_info.get_name info with
  | None -> ()
  | Some name -> let _ = match Base_info.get_container info with
   | None -> ()
   | Some container -> match Base_info.get_name container with
     | None -> ()
     | Some container_name -> print_endline (String.concat " " ["Container :";
                                                                container_name;
                                                                "function";
                                                                name])
     in
     let info' = Function_info.from_baseinfo info in
     let flags = Function_info.get_flags info' in
    let rec search = function
      | [] -> true
      | f :: q -> if f == Function_info.Is_method then false
      else search q
    in
    if search flags then (
      let f_descrs = (source_files.mli.descr,
                                   source_files.ml.descr) in
      BuilderFunction.append_ctypes_function_bindings name info' f_descrs;
      add_empty_line source_files.mli.descr;
      add_empty_line source_files.ml.descr
    )

let parse_callback_info info =
  ()

let parse_struct_info info source_files =
  match Base_info.get_name info with
  | None -> ()
  | Some name -> let f_descrs = (source_files.mli.descr,
                                 source_files.ml.descr) in
    let info' = Struct_info.from_baseinfo info in
    BuilderStruct.append_ctypes_struct_declaration name f_descrs;
    BuilderStruct.append_ctypes_struct_fields_declarations name info' f_descrs;
    BuilderStruct.append_ctypes_struct_methods_bindings name info' f_descrs;
    add_empty_line source_files.mli.descr;
    add_empty_line source_files.ml.descr

let parse_boxed_info info =
  ()

let parse_enum_info info source_files =
  match Base_info.get_name info with
  | None -> ()
  | Some name -> let f_descrs = (source_files.mli.descr,
                                 source_files.ml.descr) in
    let info' = Enum_info.from_baseinfo info in
    Bind_enum.append_ctypes_enum_bindings name info' f_descrs;
    add_empty_line source_files.mli.descr;
    add_empty_line source_files.ml.descr

let parse_flags_info info source_files =
  match Base_info.get_name info with
  | None -> ()
  | Some name -> let f_descrs = (source_files.mli.descr,
                                 source_files.ml.descr) in
    let info' = Enum_info.from_baseinfo info in
    Bind_enum.append_ctypes_flags_bindings name info' f_descrs;
    add_empty_line source_files.mli.descr;
    add_empty_line source_files.ml.descr

let parse_object_info info =
  ()

let parse_interface_info info =
  ()

let parse_constant_info info source_files =
  match Base_info.get_name info with
  | None -> ()
  | Some name -> let info' = Constant_info.from_baseinfo info in
    let type_info = Constant_info.get_type info' in
    let not_implemented_todo_comments tag (mli, ml) =
      let tag_name = Types.string_of_tag tag in
      Printf.fprintf mli "(* TODO : constant %s type not implemented for %s *)" name tag_name;
      Printf.fprintf mli "(* TODO : constant %s type not implemented for %s *)" name tag_name
    in
    let f_descrs = (source_files.mli.descr,
                    source_files.ml.descr) in
    let _ = match Type_info.get_tag type_info with
    | Types.Void as tag -> not_implemented_todo_comments tag f_descrs
    | Types.Boolean ->
      Bind_constant.append_boolean_constant name info' f_descrs
    | Types.Int8 ->
      Bind_constant.append_int8_constant name info' f_descrs
    | Types.Uint8 ->
      Bind_constant.append_uint8_constant name info' f_descrs
    | Types.Int16 ->
      Bind_constant.append_int16_constant name info' f_descrs
    | Types.Uint16 ->
      Bind_constant.append_uint16_constant name info' f_descrs
    | Types.Int32 ->
      Bind_constant.append_int32_constant name info' f_descrs
    | Types.Uint32 ->
      Bind_constant.append_uint32_constant name info' f_descrs
    | Types.Int64 ->
      Bind_constant.append_int64_constant name info' f_descrs
    | Types.Uint64 ->
      Bind_constant.append_uint64_constant name info' f_descrs
    | Types.Float ->
      Bind_constant.append_float_constant name info' f_descrs
    | Types.Double ->
      Bind_constant.append_double_constant name info' f_descrs
    | Types.GType as tag -> not_implemented_todo_comments tag f_descrs
    | Types.Utf8 ->
      Bind_constant.append_string_constant name info' f_descrs
    | Types.Filename as tag -> not_implemented_todo_comments tag f_descrs
    | Types.Array as tag -> not_implemented_todo_comments tag f_descrs
    | Types.Interface as tag -> not_implemented_todo_comments tag f_descrs
    | Types.GList as tag -> not_implemented_todo_comments tag f_descrs
    | Types.GSList as tag -> not_implemented_todo_comments tag f_descrs
    | Types.GHash as tag -> not_implemented_todo_comments tag f_descrs
    | Types.Error as tag -> not_implemented_todo_comments tag f_descrs
    | Types.Unichar as tag -> not_implemented_todo_comments tag f_descrs
    in
    add_empty_line source_files.mli.descr;
    add_empty_line source_files.ml.descr

let parse_union_info info source_files =
  match Base_info.get_name info with
  | None -> ()
  | Some name -> let f_descrs = (source_files.mli.descr,
                                 source_files.ml.descr) in
    let info' = Union_info.from_baseinfo info in
    BuilderUnion.append_ctypes_union_declaration name f_descrs;
    BuilderUnion.append_ctypes_union_fields_declarations name info' f_descrs;
    add_empty_line source_files.mli.descr;
    add_empty_line source_files.ml.descr

let parse_value_info info =
  ()

let parse_signal_info info =
  ()

let parse_vfunc_info info =
  ()

let parse_property_info info =
  ()

let parse_field_info info =
  ()

let parse_arg_info info =
  ()

let parse_type_info info =
  ()

let parse_unresolved_info info =
  ()