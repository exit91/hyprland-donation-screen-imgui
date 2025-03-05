{
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  glfw,
  freetype,
  plutovg,
  plutosvg,
}:
stdenv.mkDerivation rec {
  pname = "imgui-hypr";
  version = "1.91.8";
  outputs = [
    "out"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "ocornut";
    repo = "imgui";
    tag = "v${version}";
    hash = "sha256-+BuSAXvLvOYOmENzxd1pGDE6llWhTGVu7C3RnoVLVzg=";
  };

  mesonBuild = ./imgui-meson.build;
  postPatch = ''
    cp ${mesonBuild} ./meson.build;
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    glfw
    plutovg
    plutosvg
    freetype
  ];
}
