{ lib
, alcotest
, ansiterminal
, benchmark
, bindlib
, buildDunePackage
, calendar
, cmdliner_1_1_0
, cppo
, fetchFromGitHub
, js_of_ocaml
, js_of_ocaml-ppx
, menhir
, menhirLib ? null #for nixos-unstable compatibility.
, ocamlgraph
, pkgs
, ppx_deriving
, ppx_yojson_conv
, re
, sedlex
, ubase
, unionfind
, visitors
, z3
, zarith
, zarith_stubs_js
}:

buildDunePackage rec {
  pname = "catala";
  version = "0.6.0"; # TODO parse `catala.opam` with opam2json

  minimumOCamlVersion = "4.11";

  src = ../.;

  useDune2 = true;

  propagatedBuildInputs = [
    alcotest
    ansiterminal
    benchmark
    bindlib
    calendar
    camomile
    cmdliner_1_1_0
    cppo
    js_of_ocaml
    js_of_ocaml-ppx
    menhir
    menhirLib
    ocamlgraph
    pkgs.z3
    ppx_deriving
    ppx_yojson_conv
    re
    sedlex
    ubase
    unionfind
    visitors
    z3
    zarith
    zarith_stubs_js
  ] ++ (if isNull menhirLib then [ ] else [ menhirLib ]);
  doCheck = true;

  meta = with lib; {
    homepage = "https://catala-lang.org";
    description =
      "Catala is a domain-specific programming language designed for deriving correct-by-construction implementations from legislative texts.";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
