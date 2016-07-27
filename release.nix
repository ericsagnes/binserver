{ pkgs ? import <nixpkgs> {} }:

with pkgs;

buildPythonPackage rec {
  name = "binserver-${version}";
  version = "2.0";
  propagatedBuildInputs = with pkgs.pythonPackages; [ flask ];
  srcs = ./.;
}
