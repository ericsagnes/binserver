with import <nixpkgs> {};

buildPythonPackage rec {
  name = "binserver-${version}";
  version = "1";
  propagatedBuildInputs = with pkgs.pythonPackages; [ flask ];
  srcs = ./.;
}
