{
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  meson,
  ninja,
  plutovg,
  freetype,
}:
stdenv.mkDerivation rec {
  pname = "plutosvg";
  version = "0.0.6";
  outputs = [
    "out"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "sammycage";
    repo = "plutosvg";
    tag = "v${version}";
    hash = "sha256-BpxHVD4P4ZQ9pAvhBHjz9ns7EEsnFqvUEyDKcM2oJps=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    cmake
    ninja
  ];

  buildInputs = [
    plutovg
    freetype
  ];
}
