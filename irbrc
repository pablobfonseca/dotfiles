#!/usr/bin/ruby
require 'irb/completion'
require 'irb/ext/save-history'
require 'rubygems'

IRB.conf[:SAVE_HISTORY] = 10000000
IRB.conf[:PROMP_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT_MODE] = false
IRB.conf[:AUTO_INDENT] = true

ARGV.concat [ "--readline", "--prompt-mode", "simple" ]

begin
  require 'awesome_print'
  AwesomePrint.irb!
rescue LoadError => e
  warn "=> Unable to load awesome_print"
end

begin
  require "pry"
  Pry.start
  exit
rescue LoadError => e
  warn "=> Unable to load pry"
end

class Object
  # list methods which aren't in superclass
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end

  def find_me
    User.find_by(email: 'pablofonseca777@gmail.com')
  end
end
