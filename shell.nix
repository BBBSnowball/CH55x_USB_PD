# Usage: If you have Nix (or NixOS), use `nix-shell shell.nix` to get a shell with the required tools.
{ pkgs ? import <nixpkgs> {} }:
let
  ch55xtool = ppkgs: ppkgs.buildPythonPackage {
    pname = "ch55xtool";
    version = "0.0.1-6c6378";

    src = pkgs.fetchFromGitHub {
      owner = "BBBSnowball";
      repo  = "ch55xtool";
      rev = "d3aa8e55591193d4b6a43021b5ebfc1a6eb7c438";
      sha256 = "sha256-xIC43CPhJbXAR62/AIJvSnQBWDcVcF+N9eZ3H8ziz6U=";
    };

    propagatedBuildInputs = with ppkgs; [ pyusb ];
  };
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    gnumake sdcc
    (python3.withPackages (p: with p; [(ch55xtool p)]))
    #(python3Packages.toPythonApplication (ch55xtool python3Packages))
  ];
}
