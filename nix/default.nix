{
  stdenv,
  lib,
  pkg-config,
  cmake,
  meson,
  ninja,
  imgui-hypr,
  glfw,
  makeWrapper,
  libGL,
  wayland,
}:
stdenv.mkDerivation {
  name = "hypr-donate-pls";
  version = "0.0.0";

  src = lib.fileset.toSource {
    root = ./..;
    fileset = lib.fileset.unions [
      ../main.cpp
      ../meson.build
      ../assets
    ];
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
    makeWrapper
  ];

  buildInputs = [
    glfw
    imgui-hypr
  ];

  postFixup = ''
    wrapProgram "$out/bin/hypr-donate-pls" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
          wayland
        ]
      }" \
      --set FONT_PATH "${../assets/NotoSans.ttf}" \
      --set EMOJI_PATH "${../assets/noto-untouchedsvg.ttf}"
  '';
}
