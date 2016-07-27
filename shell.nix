{ pkgs ? import <nixpkgs> {} }:
with pkgs;

let
  python = pythonFull.withPackages (ps: [ps.flask]);
in
  python.env
