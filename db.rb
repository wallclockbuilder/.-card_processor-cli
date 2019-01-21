require 'sqlite3'
require 'active_record'

if ENV['RAILS_ENV']=='test'
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'test.sqlite3.db')
else
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'card_data.sqlite3.db')
end

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.table_exists?(:cards)
    create_table "cards", force: true do |t|
      t.string   "name"
      t.string   "number"
      t.integer  "limit"
      t.integer  "balance"
      t.index ["number"], name: "index_cards_on_number"
    end
  end
end

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class Card < ApplicationRecord
  validates :number, uniqueness: true
end

def reset_card(name)
  cc = Card.find_by_name(name)
  cc.balance = 0 if cc
  cc.save if cc
end


def add_card(name, number, limit)
  if Luhn.valid?(number)
    create_card(name, number, limit)
  else
    puts "#{name}: error"
  end
end

def create_card(name, number, limit)
  Card.create(:name =>name, :number=>number, :limit=>limit.to_f, :balance=>0)
  puts "#{name}: 0"
end

def charge(card, amount)
  card.balance += amount.to_f
  card.save
end

def charge_card(name, amount)
  card = Card.find_by_name(name)
  if !card || !Luhn.valid?(card.number)
    puts "#{name}: error"
  else
    if amount.to_f + card.balance <= card.limit
      charge(card, amount)
      puts "#{name}: #{amount}"
    else
      puts "#{name}: declined"
    end
  end
end

def credit_account(name, amount)
  card = Card.find_by_name(name)

  if !card || !Luhn.valid?(card.number)
    puts "#{name}: error"
  else
    card.balance -= amount.to_f
    card.save
    puts "#{name}: #{card.balance}"
  end

end
