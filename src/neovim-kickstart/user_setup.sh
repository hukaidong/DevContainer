git clone https://github.com/nvim-lua/kickstart.nvim.git $HOME/.config/nvim

nvim --headless "+Lazy! sync" +qa

cat "$(dirname $0)/init.rc" >> $HOME/.bashrc
cat "$(dirname $0)/init.rc" >> $HOME/.zshrc