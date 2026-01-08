{ pkgs, ... }:
let
  inherit (pkgs) lib;

  gen-pkgs =
    caller: trxm: lst:
    lib.genAttrs lst (name: caller (trxm name) { });

  make-pkgs = {
    by-name = gen-pkgs pkgs.callPackage (name: ./flatten + "/${name}/package.nix");

    python-x-packages = py: gen-pkgs pkgs.${py}.callPackage (name: ./flatten + "/${py}.${name}");

    python-packages =
      lst:
      lib.genAttrs [ "python313Packages" "python314Packages" ] (
        name: make-pkgs.python-x-packages name lst
      );

    top-level = gen-pkgs pkgs.callPackage (name: ./flatten + "/${name}");
  };

  by-name = make-pkgs.by-name [
    "apl386"
    "autotrash"
    "banana-vera"
    "boxfort"
    "bsc"
    "cano"
    "cavalcade"
    "cbeams"
    "cdecl"
    "cdecl-blocks"
    "cista"
    "compiledb"
    "concord"
    "coost"
    "cppi"
    "criterion"
    "diagrams-as-code"
    "filterpath"
    "fte"
    "fzf-make"
    "gbsplay"
    "gcovr"
    "gfold"
    "ghi"
    "git-pr"
    "git-standup"
    "hardinfo2"
    "hexedit"
    "hueadm"
    "imapdedup"
    "kitty-themes"
    "ksh"
    "libclipboard"
    "libjpeg_original"
    "liblapin"
    "libmrss"
    "libnxml"
    "liboqs"
    "libowlevelzs"
    "libsv"
    "logdy"
    "mini-calc"
    "nph"
    "owocr"
    "parson"
    "physac"
    "pie-cli"
    "project-lemonlime"
    "ps_mem"
    "ptext"
    "ragnarwm"
    "rasm"
    "raygui"
    "raygui"
    "sxcs"
    "sxcs"
    "toolong"
    "tuifimanager"
    "u-config"
    "unipicker"
    "ustr"
    "viu"
    "wakatime-cli"
    "xml-tooling-c"
    "xmoji"
    "yyjson"
  ];

  python-packages = make-pkgs.python-packages [
    "aerosandbox"
    "atopile"
    "atopile-easyeda2kicad"
    "azure-ai-vision-imageanalysis"
    "bpylist2"
    "case-converter"
    "cgen"
    "contextlib2"
    "crossandra"
    "dahlia"
    "docopt-subcommands"
    "esper"
    "ewmhlib"
    "fastapi-github-oidc"
    "fava"
    "feather-format"
    "geoparquet"
    "glob2"
    "gstools"
    "hankel"
    "hikari"
    "hikari-crescent"
    "intbitset"
    "ixia"
    "kde-material-you-colors"
    "kicadcliwrapper"
    "kicad-python"
    "libsass"
    "loguru-logging-intercept"
    "mdformat-gfm-alerts"
    "nemosis"
    "neuralfoil"
    "normality"
    "objexplore"
    "oddsprout"
    "osxphotos"
    "outspin"
    "pandoc-latex-environment"
    "paperbush"
    "patchpy"
    "pbar"
    "protoletariat"
    "pycdio"
    "pydy"
    "pyevtk"
    "pyfunctional"
    "pygments"
    "pymee"
    "pymonctl"
    "pyopengltk"
    "pyperclipfix"
    "pytest-mypy"
    "pywinbox"
    "pywinctl"
    "qtile"
    "qtile-bonsai"
    "quart-schema"
    "raylib-python-cffi"
    "rich-theme-manager"
    "samarium"
    "shiny"
    "sigparse"
    "sphinxawesome-theme"
    "sphinx-last-updated-by-git"
    "strpdatetime"
    "sure"
    "tinytag"
    "utitools"
    "wsme"
    "yaxmldiff"
    "yt-dlp-dearrow"
  ];
in
{ }
// by-name
// python-packages
// {
  inherit (python-packages.python313Packages) atopile fava oddsprout;

  linux-doc = pkgs.callPackage ./flatten/linux-doc/htmldocs.nix { };

  tipp10 = pkgs.qt6.callPackage ./flatten/tipp10 { };
}
