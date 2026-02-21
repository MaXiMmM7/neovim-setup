# For fzf-lua
dest="/usr/local/bin" && \
tmpdir=$(mktemp -d) && \
cd "$tmpdir" && \
curl -L "https://github.com/junegunn/fzf/releases/download/v0.67.0/fzf-0.67.0-linux_amd64.tar.gz" | tar xz && \
sudo cp fzf "$dest" && \
cd / && rm -rf "$tmpdir"

#ripgrep

#Nerd Font 
#https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/IntelOneMono.zip
#https://gist.github.com/matthewjberger/7dd7e079f282f8138a9dc3b045ebefa0


#for treesitter
dest="/usr/local/bin" && \
tmpdir=$(mktemp -d) && \
cd "$tmpdir" && \
wget -q "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.5/tree-sitter-linux-x64.gz" && \
gunzip tree-sitter-linux-x64.gz && \
sudo cp tree-sitter-linux-x64 "$dest" && \
cd / && rm -rf "$tmpdir" && \
sudo chmod +x ${dest}/tree-sitter-linux-x64 && \
sudo ln -s ${dest}/tree-sitter-linux-x64 ${dest}/tree-sitter

# for nvim-lint install linter executable for each plugin for example isntall cppcheck
