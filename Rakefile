$:.push File.expand_path("../lib", __FILE__)

require 'rake'
require 'environment'

desc "Install dotfiles and related libraries"
task install: %w(dotfiles:install shell:install vim:install)

desc "Update dotfiles and related libraries"
task update: %w(dotfiles:update shell:update vim:update)

task default: :update

namespace :dotfiles do
  desc "Install dotfiles"
  task :install do
    Environment::Dotfiles.new(path: ENV['DOTFILES']).install
  end

  desc "Update dotfiles"
  task :update do
    Environment::Dotfiles.new(path: ENV['DOTFILES']).update
  end
end

namespace :shell do
  desc "Install vim plugins"
  task :install do 
    Environment::Vim.new.install
    Environment::Vim::Plugins.new.install
  end

  desc "Update vim plugins"
  task :install do 
    Environment::Vim.new.update
    Environment::Vim::Plugins.new.update
  end
end

namespace :shell do
  desc "Install Oh-my-zsh and change default shell"
  task :install do
    Environment::Shell.new.install
    Environment::Shell.new.setup
  end

  desc "Update Oh-my-zsh"
  task :update do
    Environment::Shell.new.update
  end
end
