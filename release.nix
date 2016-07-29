{ # Hydraのjobsetで定義できるように変数を指定
  nixpkgs ? <nixpkgs>
, systems ? ["i686-linux" "x86_64-linux" ]
}:

let

  mkChannel = { src, constituents ? [], name }:
    pkgs.stdenv.mkDerivation {
      inherit name src constituents;
      preferLocalBuild = true;
      _hydraAggregate = true;

      phases = [ "unpackPhase" "installPhase" ];

      installPhase = ''
        mkdir -p "$out/tarballs" "$out/nix-support"

        tar cJf "$out/tarballs/nixexprs.tar.xz" \
          --owner=0 --group=0 --mtime="1970-01-01 00:00:00 UTC" \
          --transform='s!^\.!${name}!' .
        
        echo "channel - $out/tarballs/nixexprs.tar.xz" \
          > "$out/nix-support/hydra-build-products"

        echo $constituents > "$out/nix-support/hydra-aggregate-constituents"
        for i in $constituents; do
          if [ -e "$i/nix-support/failed" ]; then
            touch "$out/nix-support/failed"
          fi
        done
      '';
      meta = {
       isHydraChannel = true;
      };
    };

  # vanilla nixpkgs
  pkgs = import nixpkgs {};

  # build.nixをインポートするヘルパー
  buildFun = import ./build.nix;

  jobs = rec {
    # 各システムのパッケージを生成する
    # -> { "i686-linux" = ...; "x86_64-linux" = ...; };
    build = pkgs.lib.genAttrs systems (system:
      buildFun {
        # システムアーキテクチャ別のnixpkgs
        pkgs = import nixpkgs { inherit system; };
      }
    );

    channel = mkChannel {
      name = "binserver-channel";
      constituents = pkgs.lib.attrValues build;
      src = ./.; 
    };
  };

in
  jobs
