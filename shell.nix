with import <nixpkgs> {};

(python.buildEnv.override {
 extraLibs = with pythonPackages;
 [ 
   # Used python2 packages
   # python3 packages can be listed with 
   # nix-env -f "<nixpkgs>" -qaP -A python2Packages
   flask

 ];
}).env
