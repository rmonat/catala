{ lib
, buildDunePackage
, odoc
, re
}:

buildDunePackage rec {
  pname = "ninja_utils";
  version = "0.6.0"; # TODO parse `catala.opam` with opam2json

  minimumOCamlVersion = "4.11";

  src = ../.;

  useDune2 = true;

  propagatedBuildInputs = [
    odoc
    re
  ];
  doCheck = true;

  meta = with lib; {
    homepage = "https://catala-lang.org";
    description =
      "A collection of utility functions used to generate Ninja build files";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
