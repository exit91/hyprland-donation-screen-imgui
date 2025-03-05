{
  stdenv,
  fetchFromGitHub,
  cmake,
  meson,
  ninja,
}:
stdenv.mkDerivation rec {
  pname = "plutovg";
  version = "0.0.13";
  outputs = [
    "out"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "sammycage";
    repo = "plutovg";
    tag = "v${version}";
    hash = "sha256-zmF64qpOwL3QHfp1GznN4TDydjGyhw8IgXYlpCEGXHg=";
  };

  nativeBuildInputs = [
    meson
    cmake
    ninja
  ];
}
