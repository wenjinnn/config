git clone --bare https://github.com/hewenjin/config.git $HOME/.cfg
function cfg {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}
cfg checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} {}.bak
fi;
cfg checkout
cfg config status.showUntrackedFiles no
