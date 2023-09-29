{ pkgs }:
let
  p = with pkgs; [
    efm-langserver
    fzf
    lua-language-server
    neovim
    pyright
    (python310.withPackages (p: [p.virtualenv p.ipython p.pipx]))
    python310Packages.virtualenvwrapper
    ripgrep
    terraform-ls
    tmux
  ];
in
p
