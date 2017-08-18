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

open OUnit2
open TestUtils
open GObjectIntrospection

let test_get_default test_ctxt =
  let _ = Repository.get_default () in
  assert_equal_boolean true true

let test_require test_ctxt =
  let repo = Repository.get_default () in
  let namespace = "Gio" in
  let _ = Repository.require repo namespace () in
  assert_equal_boolean true true

let namespace = "Gio"
let repo = Repository.get_default ()
let typelib = Repository.require repo namespace ()

let test_get_loaded_namespaces test_ctxt =
  let namespaces_check = "GLib GObject Gio" in
  let namespaces = String.concat " " (Repository.get_loaded_namespaces repo) in
  assert_equal_string namespaces_check namespaces

let test_get_dependencies test_ctxt =
  let dependencies_check = "GLib-2.0 GObject-2.0" in
  let dependencies = String.concat " " (Repository.get_dependencies repo namespace) in
  assert_equal_string dependencies_check dependencies

let test_get_c_prefix test_ctxt =
  let c_prefix = Repository.get_c_prefix repo namespace in
  assert_equal_string "G" c_prefix

let test_get_version test_ctxt =
  let version = Repository.get_version repo namespace in
  assert_equal_string "2.0" version

let test_get_typelib_path text_ctxt =
  let path = Repository.get_typelib_path repo namespace in
  assert_equal_string "/usr/lib/girepository-1.0/Gio-2.0.typelib" path

let test_enumerate_versions test_ctxt =
  let versions_check = "2.0 2.0" in
  let versions = String.concat " " (Repository.enumerate_versions repo namespace) in
  assert_equal_string versions_check versions

let test_get_search_path test_ctxt =
  let path = String.concat " " (Repository.get_search_path ()) in
  assert_equal_string "/usr/lib/girepository-1.0" path

let test_prepend_search_path test_ctxt =
  let initial_path = String.concat " " (Repository.get_search_path ()) in
  let new_path = "/home/myhome" in
  let _ = Repository.prepend_search_path new_path in
  let paths = String.concat " " (Repository.get_search_path ()) in
  let initial_paths = String.concat " " [new_path; initial_path] in
  assert_equal_string initial_paths paths

let test_find_by_name test_ctxt =
  let info_name = "Application" in
  match Repository.find_by_name repo namespace info_name with
  | None -> assert_equal_string info_name "No base info found"
  | Some (base_info) -> match GIBaseInfo.get_name base_info with
    | None -> assert_equal_string info_name "No name found"
    | Some name -> assert_equal_string info_name name

let test_get_n_infos test_ctxt =
  let n_infos = Repository.get_n_infos repo namespace in
  assert_equal_int 702 n_infos

let test_get_info_out_of_bounds test_ctxt =
  try ignore (Repository.get_info repo namespace 1500)
  with
  | Failure message -> assert_equal_string "Array Index out of bounds"
                                              message
  | _ -> assert_equal_string "Bad exception" "Not a Failure"

let test_get_info test_ctxt =
  let info_name = "Action" in
  let info = Repository.get_info repo namespace 0 in
  match GIBaseInfo.get_name info with
  | None -> assert_equal_string info_name "No name found"
  | Some name -> assert_equal_string info_name name

let test_get_shared_library test_ctxt =
  match Repository.get_shared_library repo namespace with
  | None -> assert_equal_string "It should return " "something"
  | Some shared_lib -> assert_equal_string "libgio-2.0.so.0" shared_lib

let tests =
  "GObject Introspection Repository tests" >:::
    [
      "Repository get default" >:: test_get_default;
      "Repository require" >:: test_require;
      (* Disable for compatibility with Travis
       * "Repository get dependencies" >:: test_get_dependencies; *)
      (* Disable because there is only one instance of Repository and those
       * namespaces depends on the nampespaces loaded previously and can
       * interfers with previous test.
       * "Repository get loaded namespaces" >:: test_get_loaded_namespaces;*)
      "Repository get c prefix" >:: test_get_c_prefix;
      "Repository get version" >:: test_get_version;
      "Repository get typelib path" >:: test_get_typelib_path;
      "Repository enumerate versions" >:: test_enumerate_versions;
      "Repository get search path" >:: test_get_search_path;
      "Repository prepend search path" >:: test_prepend_search_path;
      "Repository find by name" >:: test_find_by_name;
      (* Disable for compatibility with Travis
      "Repository get n infos" >:: test_get_n_infos *)
      "Repository get info out of bounds" >:: test_get_info_out_of_bounds;
      "Repository get info" >:: test_get_info;
      "Repository get shared library" >:: test_get_shared_library
    ]
