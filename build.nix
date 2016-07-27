{ pkgs ? import <nixpkgs> {} }:

pkgs.buildPythonPackage rec {

  name = "binserver-${version}";
  version = "2.0";
  propagatedBuildInputs = with pkgs.pythonPackages; [ flask ];
  src = ./.;

  meta = {
    description = "server converting decimal to binary";
    maintainers = with pkgs.lib.maintainers; [ ericsagnes ];
  };

}
