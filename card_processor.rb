#!/usr/bin/env ruby


require 'luhn'
require 'pry'
require_relative 'db'

case ARGV[0]
when "Add"
  add_card(ARGV[1], ARGV[2], ARGV[3])
when "Charge"
  charge_card(ARGV[1], ARGV[2])
when "Credit"
  credit_account(ARGV[1], ARGV[2])
else
  if ARGV[0]
    file = ARGV[0]
    File.readlines(file).each do |command|
      puts '=-=--=-=-='
      p file
      system("./card_processor.rb #{command}")
    end
  elsif ARGF
    ARGF.each {|cmd| system("./card_processor.rb #{cmd}")}
  end
    puts "=--=-=-=--=-==--="
end
