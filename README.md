# **USAGE**

Troubleshoot: Because of the large amount of submodules, if you ever have any
trouble after pulling from the repository, it will be easier to just back up
your old .vim folder and just git clone a new version.

Clone this repo into your home directory either as .vim (linux/mac). Such as:

```
git clone git://github.com/pablobfonseca/dotfiles.git
```

## VIM
Now you should create a new `.vimrc` file in your home directory that
loads the pre-configured one that comes bundled in this package. You can do it
on Linux/Mac like this:
```linux
ln -s .dotfiles/vim/vimrc ~/.vimrc
```

## tmux

Create a `tmux.conf` file in your home directory on Linux/Mac like this:
```linux
ln -s .dotfiles/tmux ~/.tmux && ln -s .dotfiles/tmux/tmux.conf ~/.tmux.conf
```

PS: Put [Tmux Navigator](https://github.com/christoomey/vim-tmux-navigator) in
your `.vimrc`

# **Help Tags**
At first usage of vim, type “:” while in command mode and execute:

call pathogen#helptags()
This will make the plugins documentations available upon :help

# **Learn VIM**
Visit the following sites to learn more about Vim:

* [Learn Vim Progressively](http://yannesposito.com/Scratch/en/blog/Learn-Vim-Progressively/)
* [Vim Adventures](http://vim-adventures.com/)
* [Vimcasts](http://vimcasts.org)
* [Using Vim as a Complete Ruby on Rails IDE](http://biodegradablegeek.com/2007/12/using-vim-as-a-complete-ruby-on-rails-ide/)
* [Why, oh WHY, do those #?@! nutheads use vi?](http://www.viemu.com/a-why-vi-vim.html)
* [Byte of Vim](http://www.swaroopch.com/notes/Vim)
* [Screencast "17 tips for Vim" (in portuguese)](http://blog.lucascaton.com.br/?p=1081)
* [MinuteVim Tricks](https://www.youtube.com/user/MinuteVimTricks)
* [Join the Church of Vim, and you too can be a saint!](http://www.avelino.xxx/2015/03/church-vim)

There are many sites teaching Vim, if you know of any other that are easy
to follow for newcomers, let me know.


## Customize tmux

[Making tmux Pretty and Usable](http://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/)
