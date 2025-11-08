{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system;
        config.allowUnfree = true;
      };
      python = pkgs.python312;
      pythonPackages = pkgs.python312Packages;
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pythonPackages; [
          # Core Python environment
          python

          # Scientific / ML stack
          numpy
          scipy
          matplotlib

          # Dev tools
          black
          flake8
          isort
          mypy
          pytest

          # Additional utilities
          fabric
          fire
          cma
          rpyc
          pyqtgraph
          influxdb-client
        ];

        # Add CUDA toolkit for torch
        nativeBuildInputs = with pkgs.cudaPackages; [ cudatoolkit ];

        shellHook = ''
          echo "🐍 Python dev shell ready with linien stack."
        '';
      };
    };
}
