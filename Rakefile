require 'rake'

desc "Install the dotfiles into $HOME"
task :install do
  replace_all = false
  Dir['*'].each do |file|
    next if %w[Rakefile README.md LICENCE id_rsa.pub].includ? file

    if File.exist?(File.join(ENV['HOME'], "#{file}"))
      if replace_all
        replace_file(file)
      else
        print "Overwrite ~/.#{file}? [ynaq]"
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "Skipping ~/.#{file}"
        end
      end
    else
      link_file(file)
    end
  end

  # Handle ssh pubkey on its own
  puts "Linking public ssh key"
  system %Q{rm "$HOME/.ssh/id_dsa.pub"}
  system %Q{ln -s "$PWD/id_dsa.pub" "$HOME/.ssh/id_dsa.pub"}

  system %Q{ mkdir ~/.tmp }
end

def replace_file file
  system %Q{ rm "$HOME/.#{file}" }
  link_file file
end

def link_file file
  puts "Linking ~/.#{file}"
  system %Q{ ln -s "$PWD/#{file}" "$HOME/.#{file}"}
end
