# Usage: If you have Nix (or NixOS), use `nix-shell shell.nix` to get a shell with the required tools.
{ pkgs ? import <nixpkgs> {} }:
let
  ch55xtool = ppkgs: ppkgs.buildPythonPackage {
    pname = "ch55xtool";
    version = "0.1-8bf717";

    src = pkgs.fetchFromGitHub {
      owner = "MarsTechHAN";
      repo  = "ch552tool";
      rev = "8bf717da5787afb11a4b29ac51035fe47e0a724e";
      sha256 = "sha256-TOT0ix+dYLpyhoNtc9lqCgRdvnXsmaxmCckigaVy4V0=";
    };

    propagatedBuildInputs = with ppkgs; [ pyusb ];

    preBuild = ''
      sed -i 's/pyusb>=1.1.0/pyusb>=1.0/' setup.py
      sed -i 's/\])$/], entry_points={"console_scripts": ["ch55xtool = ch55xtool.ch55xtool:main"]})/' setup.py

      mkdir bin
      cat >bin/ch55xtool <<EOF
      #!/usr/bin/env python
      exec python -m ch55xtool "$@"
      EOF
    '';
  };
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    gnumake sdcc
    (python3.withPackages (p: with p; [(ch55xtool p)]))
    #(python3Packages.toPythonApplication (ch55xtool python3Packages))
  ];
}
