{
  description = "buzz-elixir";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      lib = pkgs.lib;

      beamPackages = pkgs.beam.packagesWith pkgs.beam.interpreters.erlang_27;
      elixir = beamPackages.elixir_1_17;
    in {
      devShell = pkgs.mkShell {
        buildInputs = [
          elixir
          pkgs.elixir_ls
          pkgs.inotify-tools
          pkgs.mix2nix
        ];

        shellHook = ''
          mkdir -p .nix-mix .nix-hex
          export MIX_HOME=$PWD/.nix-mix
          export HEX_HOME=$PWD/.nix-mix
          export PATH=$MIX_HOME/bin:$HEX_HOME/bin:$PATH
          mix local.hex --force

          export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_path '\"$PWD/.erlang-history\"'"
          export FRONT=http://buzz.lcl:3000
        '';
      };

      packages.default = beamPackages.mixRelease {
        src = ./.;
        pname = "buzz-phoenix";
        version = "0.1.0";

        FRONT = "https://buzz.rusty-cluster.net";
        mixNixDeps = import ./deps.nix {inherit lib beamPackages;};
      };
    });
}
