sh .travis-ocaml.sh
export OPAMYES=1
eval `opam config env`
opam install ocamlfind
opam install ounit
opam install oasis
sh .travis-gobject-introspection.sh
ruby _oasis_conf.rb > _oasis
sh build_and_test.sh