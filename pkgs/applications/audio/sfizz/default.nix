{ lib, stdenv, fetchFromGitHub, libjack2, libsndfile, xorg, freetype
, libxkbcommon, cairo, glib, gnome, flac, libogg, libvorbis, libopus, cmake
, pango, pkg-config }:

stdenv.mkDerivation rec {
  pname = "sfizz";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "sfztools";
    repo = pname;
    rev = version;
    sha256 = "1gzpbns89j6ggzfjjvyhgigynsv20synrs7lmc32hwp4g73l0j7n";
    fetchSubmodules = true;
  };

  buildInputs = [
    libjack2
    libsndfile
    flac
    libogg
    libvorbis
    libopus
    xorg.libX11
    xorg.libxcb
    xorg.libXau
    xorg.libXdmcp
    xorg.xcbutil
    xorg.xcbutilcursor
    xorg.xcbutilrenderutil
    xorg.xcbutilkeysyms
    xorg.xcbutilimage
    libxkbcommon
    cairo
    glib
    gnome.zenity
    freetype
    pango
  ];
  nativeBuildInputs = [ cmake pkg-config ];

  postPatch = ''
    substituteInPlace plugins/editor/external/vstgui4/vstgui/lib/platform/linux/x11fileselector.cpp \
      --replace 'zenitypath = "zenity"' 'zenitypath = "${gnome.zenity}/bin/zenity"'
    substituteInPlace plugins/editor/src/editor/NativeHelpers.cpp \
      --replace '/usr/bin/zenity' '${gnome.zenity}/bin/zenity'
  '';

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" "-DSFIZZ_TESTS=ON" ];

  meta = with lib; {
    homepage = "https://github.com/sfztools/sfizz";
    description = "SFZ jack client and LV2 plugin";
    license = licenses.bsd2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.all;
    badPlatforms = platforms.darwin;
  };
}
