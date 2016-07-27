{ # Hydraのjobsetで定義できるように変数を指定
  nixpkgs ? <nixpkgs>
, systems ? ["i686-linux" "x86_64-linux" ]
}:

let

  # vanilla nixpkgs
  pkgs = import nixpkgs {};

  # build.nixをインポートするヘルパー
  buildFun = import ./build.nix;

  jobs = {
    # 各システムのパッケージを生成する
    # -> { "i686-linux" = ...; "x86_64-linux" = ...; };
    build = pkgs.lib.genAttrs systems (system:
      buildFun {
        # システムアーキテクチャ別のnixpkgs
        pkgs = import nixpkgs { inherit system; };
      }
    );
  };

in
  jobs
