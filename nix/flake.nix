{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem [ "aarch64-darwin" "aarch64-linux" "x86_64-linux" ] (system:
        let
            pkgs = import nixpkgs { inherit system; };
            myPackages = import ./packages.nix { inherit pkgs; }; 
        in
        {
            packages.default = pkgs.buildEnv {
                name = "default profile";
                paths = myPackages;
            };
            devShells.default = pkgs.mkShell {
                packages = myPackages;
            };
        });
}
