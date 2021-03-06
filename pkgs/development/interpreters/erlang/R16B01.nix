{ stdenv, fetchurl, perl, gnum4, ncurses, openssl
, wxSupport ? false, mesa ? null, wxGTK ? null, xlibs ? null }:

assert wxSupport -> mesa != null && wxGTK != null && xlibs != null;

let version = "16B01"; in

stdenv.mkDerivation {
  name = "erlang-" + version;

  src = fetchurl {
    url = "http://www.erlang.org/download/otp_src_R16B01.tar.gz";
    sha256 = "1h5b2mil79z307mc7ammi38qnd8f50n3sv5vyl4d1gcfgg08nf6s";
  };

  buildInputs =
    [ perl gnum4 ncurses openssl
    ] ++ stdenv.lib.optional wxSupport [ mesa wxGTK xlibs.libX11 ];

  patchPhase = '' sed -i "s@/bin/rm@rm@" lib/odbc/configure erts/configure '';

  preConfigure = ''
    export HOME=$PWD/../
    sed -e s@/bin/pwd@pwd@g -i otp_build
  '';

  configureFlags = "--with-ssl=${openssl}";

  meta = {
    homepage = "http://www.erlang.org/";
    description = "Programming language used for massively scalable soft real-time systems";

    longDescription = ''
      Erlang is a programming language used to build massively scalable
      soft real-time systems with requirements on high availability.
      Some of its uses are in telecoms, banking, e-commerce, computer
      telephony and instant messaging. Erlang's runtime system has
      built-in support for concurrency, distribution and fault
      tolerance.
    '';

    platforms = stdenv.lib.platforms.linux;
    # Note: Maintainer of prev. erlang version was simons. If he wants
    # to continue maintaining erlang I'm totally ok with that.
    maintainers = [ stdenv.lib.maintainers.the-kenny ];
  };
}
