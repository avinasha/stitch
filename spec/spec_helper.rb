require 'rubygems'
require 'bundler/setup'
require 'pry'

require 'active_record'

require 'stitch'

RSpec.configure do |config|
  config.mock_with :flexmock
end

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
ActiveRecord::Migration.create_table :tickets do |t|
  t.timestamps
end

class Ticket < ActiveRecord::Base
  trigger_event 'ticket.created', after_create: {on: :create}
end

class Resque
  def enqueue
  end
end


class TicketObserver < Stitch::Event::Observer
  def ticket_created
  end
end

Ticket.new.save

