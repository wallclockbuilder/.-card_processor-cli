ENV['RAILS_ENV'] ||= 'test'

require 'open3'
require 'rspec'
require_relative 'db'

describe 'card_processor.rb' do
  commands = {
  'Add Quincy 1234567890123456 2000'=> 'Quincy: error',
  'Add Tom 4111111111111111 1000'=>'Tom: 0',
  'Add Lisa 5454545454545454 3000'=>'Lisa: 0',
  'Charge Tom 500'=>'Tom: 500',
  'Charge Tom 800'=>'Tom: declined',
  'Charge Lisa 7'=>'Lisa: 7',
  'Charge Quincy 200'=>'Quincy: error',
  'Credit Lisa 100'=>'Lisa: -93',
  'Credit Quincy 200'=>'Quincy: error'}

  ['Tom','Lisa'].each {|i| reset_card(i)} if ENV['RAILS_ENV']=='test'

  commands.each do |command|
    cmd = "./card_processor.rb #{command[0]}"
    expected_result = command[1]
    output, status = Open3.capture2(cmd)
    p "=--=-==--==-"
    p cmd
    p expected_result

    it "responds to #{cmd} with #{expected_result}" do
      expect(output).to include(expected_result)
    end
  end
end
