{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      forEachSystem = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      packages = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          fhs = pkgs.buildFHSEnv {
            name = "calc-fhs";
            targetPkgs =
              pkgs:
              (with pkgs; [
                # 3.13 until 3.14 is supported by torch
                (python313.withPackages (p: [ p.uv ]))
                zlib
              ]);
          };
        in
        {
          fhs = fhs;
        }
      );
    };
}
