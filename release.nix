with import <nixpkgs> {};

buildPythonPackage rec {
  name = "binserver-${version}";
  version = "1.0";
  propagatedBuildInputs = with pkgs.pythonPackages; [ flask ];
  srcs = ./.;
}
