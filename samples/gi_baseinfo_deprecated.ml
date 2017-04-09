let () =
  let namespace = "Gtk" in
  let repo = GIRepository.get_default () in
  let _ = GIRepository.require repo namespace in
  let n = GIRepository.get_n_infos repo namespace in
  for i = 0 to (n - 1) do
    match GIRepository.get_info repo namespace n with
    | None -> ()
    | Some (info) -> if GIBaseInfo.is_deprecated info then
        let message = String.concat " " ["GIBaseInfo number"; string_of_int n; GIBaseInfo.get_name info]
        in print_endline message
  done
