open Ctypes

type t
val t_typ : t structure typ
val f_data: (unit ptr, t structure) field
val f_next: ((* interface *) Node.t structure ptr, t structure) field
val f_prev: ((* interface *) Node.t structure ptr, t structure) field
val f_parent: ((* interface *) Node.t structure ptr, t structure) field
val f_children: ((* interface *) Node.t structure ptr, t structure) field
val child_index:
t structure ptr -> unit ptr option -> int32

val child_position:
t structure ptr -> (* interface *) t structure ptr -> int32

val depth:
t structure ptr -> Unsigned.uint32

val destroy:
t structure ptr -> unit

val is_ancestor:
t structure ptr -> (* interface *) t structure ptr -> bool

val max_height:
t structure ptr -> Unsigned.uint32

val n_children:
t structure ptr -> Unsigned.uint32

val n_nodes:
t structure ptr -> (* interface *) Traverse_flags.t_list -> Unsigned.uint32

val reverse_children:
t structure ptr -> unit

val unlink:
t structure ptr -> unit

