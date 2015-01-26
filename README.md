# **USAGE**

Troubleshoot: Because of the large amount of submodules, if you ever have any
trouble after pulling from the repository, it will be easier to just back up
your old .vim folder and just git clone a new version.

Clone this repo into your home directory either as .vim (linux/mac) or
vimfiles (Windows). Such as:

```
git clone git://github.com/pablobfonseca/vim-files.git ~/.vim
```

Now you should create a new `.vimrc` file in your home directory that
loads the pre-configured one that comes bundled in this package. You can do it
on Linux/Mac like this:
```
ln -s .vim/.vimrc .vimrc
```
On Windows you should create a _vimrc (underline instead of dot) and add
the following line inside:
```
source ~/vim-files/vimrc
```

# **HELP TAGS**
At first usage of vim, type “:” while in command mode and execute:

call pathogen#helptags()
This will make the plugins documentations available upon :help

# **LEARN VIM**
Visit the following sites to learn more about Vim:  
- http://vimcasts.org/

There are many sites teaching Vim, if you know of any other that are easy
to follow for newcomers, let me know.

# **CREDITS**
- Original project and most of the heavy lifting: @scrooloose
- All the cool plugins for Rails, Cucumber and more: @timpope
- Hacks and some snippets: @akitaonrails
- Some configs: @pablobfonseca
