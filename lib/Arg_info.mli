(*
 * Copyright 2017-2019 Cedric LE MOIGNE, cedlemo@gmx.com
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

(** Arg_info — Struct representing an argument *)

open Ctypes

(** Arg_info represents an argument. An argument is always part of a
    Callable_info. *)
type t
val arginfo : t structure typ

(** Obtain the direction of the argument. Check GIDirection for possible
    direction values.*)
val get_direction:
  t structure ptr -> Bindings.Arg_info.direction

(** Obtain the index of the user data argument. This is only valid for
    arguments which are callbacks. Returns index of the user data argument or
    -1 if there is none. *)
val get_closure:
  t structure ptr -> int

(** Obtains the index of the GDestroyNotify argument. This is only valid for
    arguments which are callbacks. Returns index of the GDestroyNotify argument
    or -1 if there is none *)
val get_destroy:
  t structure ptr -> int

(** Obtain the ownership transfer for this argument. GITransfer contains a list
    of possible values. *)
val get_ownership_transfer:
  t structure ptr -> Bindings.Arg_info.transfer

(** Obtain if the type of the argument includes the possibility of NULL. For
    'in' values this means that NULL is a valid value. For 'out' values, this
    means that NULL may be returned. See also Arg_info.is_optional. *)
val may_be_null:
  t structure ptr -> bool

(** Obtain if the argument is a pointer to a struct or object that will receive
    an output of a function. The default assumption for Arg_info.Out arguments
    which have allocation is that the callee allocates; if this is TRUE, then
    the caller must allocate. *)
val is_caller_allocates:
  t structure ptr -> bool

(** Obtain if the argument is optional. For 'out' arguments this means that you
    can pass NULL in order to ignore the result. *)
val is_optional:
  t structure ptr -> bool

(** Obtain if the argument is a return value. It can either be a parameter or a
    return value. *)
val is_return_value:
  t structure ptr -> bool

(** Obtain if an argument is only useful in C. *)
val is_skip:
  t structure ptr -> bool

val get_scope:
  t structure ptr -> Bindings.Arg_info.scope_type

(** Taken from GObject
    Through the GParamFlags flag values, certain aspects of parameters can be
    configured. *)

type param_flags =
  | Readable        (** the parameter is readable *)
  | Writable        (** the parameter is writable *)
  | Readwrite       (** alias for G_PARAM_READABLE | G_PARAM_WRITABLE *)
  | Construct       (** the parameter will be set upon object construction *)
  | Construct_only  (** the parameter can only be set upon object construction *)
  | Lax_validation  (** upon parameter conversion (see g_param_value_convert())
                        strict validation is not required *)
  | Static_name     (** the string used as name when constructing the parameter
                        is guaranteed to remain valid and unmodified for the
                        lifetime of the parameter. Since 2.8 *)
  | Private         (** internal *)
  | Static_nick     (** the string used as nick when constructing the parameter
                        is guaranteed to remain valid and unmmodified for the
                        lifetime of the parameter. Since 2.8 *)
  | Static_blurb    (** the string used as blurb when constructing the parameter
                        is guaranteed to remain valid and unmodified for the
                        lifetime of the parameter. Since 2.8 *)
  | Explicit_notify (** calls to g_object_set_property() for this property will
                        not automatically result in a "notify" signal being
                        emitted: the implementation must call g_object_notify()
                        themselves in case the property actually changes.
                        Since: 2.42. *)
  | Deprecated      (** the parameter is deprecated and will be removed in a
                        future version. A warning will be generated if it is
                        used while running with G_ENABLE_DIAGNOSTIC=1.
                        Since 2.26 *)

val param_flags_of_int32:
  int32 -> param_flags

val param_flags_to_string:
  param_flags -> string

val get_type:
  t structure ptr -> Type_info.t structure ptr

(*
  TODO : void	g_arg_info_load_type ()
*)

(** Just cast OCaml Ctypes base info to arg info. *)
val cast_from_baseinfo:
  Base_info.t structure ptr -> t structure ptr

(** Just cast OCaml Ctypes arg info to base info *)
val cast_to_baseinfo:
  t structure ptr -> Base_info.t structure ptr

(** Add unref of the C underlying structure whith Gc.finalise. *)
val add_unref_finaliser:
  t structure ptr -> t structure ptr

(** Return a Arg_info.t from a Base_info.t, the underlying C structure
    ref count is increased and the value is Gc.finalis"ed" with
    Base_info.baseinfo_unref. *)
val from_baseinfo:
  Base_info.t structure ptr -> t structure ptr

(** Return a Base_info.t form a Arg_info, the underlying C structure
    ref count is increased and the value is Gc.finalis"ed" with
    Base_info.baseinfo_unref. *)
val to_baseinfo:
  t structure ptr -> Base_info.t structure ptr
