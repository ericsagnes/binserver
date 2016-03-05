# Binserver

NixOS/NixOps用のサンプルPythonサーバアプリケーション。

## ビルドする

```
nix-build release.nix
```

## 実行する

```
nix-shell --run "python app/binserver.py"
```

## 開発環境に入る

```
nix-shell
```

## コンテナーで利用する

```
let
  binserverSrc = pkgs.fetchFromGitHub {
      owner  = "ericsagnes";
      repo   = "binserver";
      rev    = "v1.0";
      sha256 = "1nhlmchh7565vcx68lscn0g9agxk5vk3bkr7h3a3fwwl696prbjb";
  };
in
{
  containers.binserver = {

    privateNetwork = true;
    hostAddress    = "10.0.0.1";
    localAddress   = "10.0.0.2";


    config = { config, pkgs, ... }: {

      imports = [ "${binserverSrc}/module.nix" ];

      services.binserver.enable = true;

      networking = {
        firewall.allowedTCPPorts = [ 80 ];
      };

      services.nginx = {
        enable = true;
        config = ''
          events {}
          http {
            server {
              listen 80;
              location / {
                proxy_pass          http://127.0.0.1:8080;
                proxy_http_version  1.1;
              }
            }
          }
        '';
      };


    };
  };
}
```

```
$ curl 10.0.0.2:8080/123
1111011
```

# NixOpsで利用する


```
{
  network.description = "Web server";

  webserver = { config, pkgs, ... }:
    let
      binserverSrc = (import <nixpkgs> {}).fetchFromGitHub {
          owner  = "ericsagnes";
          repo   = "binserver";
          rev    = "v1.0";
          sha256 = "1nhlmchh7565vcx68lscn0g9agxk5vk3bkr7h3a3fwwl696prbjb";
      };
    in
    {

      imports = [ "${binserverSrc}/module.nix" ]; 

      services.binserver.enable = true;

      networking = {
        firewall.allowedTCPPorts = [ 80 ];
      };

      services.nginx = {
        enable = true;
        config = ''
          events {}
          http {
            server {
              listen 80;
              location / {
                proxy_pass          http://127.0.0.1:8080;
                proxy_http_version  1.1;
              }
            }
          }
        '';
      };

    };
}
```
