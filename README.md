# @pablobfonseca's dotfiles

# **Help Tags**
Everything you need to know about vim is in the vim inner documentation, so go
ahead and type `:help` inside vim!

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
* [Vim Golf](http://vimgolf.com/)

There are many sites teaching Vim, if you know of any other that are easy
to follow for newcomers, let me know.

## Installation
```sh
mkdir ~/work
git clone https://github.com/pablobfonseca/dotfiles.git ~/work/dotfiles
cd ~/work/dotfiles
rake install
```

### All tasks: Install & Update
```ruby
rake dotfiles:install  # Install dotfiles
rake dotfiles:update   # Update dotfiles
rake install           # Install dotfiles and related libraries
rake shell:install     # Install Oh-My-Zsh and change default shell
rake shell:update      # Update Oh-My-Zsh
rake update            # Update dotfiles, vim and shell libraries
rake vim:install       # Install Vim plugins
rake vim:update        # Update Vim plugins
```


## Customize tmux

[Making tmux Pretty and Usable](http://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/)
