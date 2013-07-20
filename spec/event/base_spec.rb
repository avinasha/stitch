require 'spec_helper'

describe Stitch::Event::Base do
  context "#method_name" do
    it "should return underscorized event name" do
      event = Stitch::Event::Base.new(:'ticket.created', Time.now, {})
      event.method_name.should == 'ticket_created' 
    end
  end

  context "Compress data" do
    it "should retain only ids instead of ActiveRecord Objects in data" do
      ticket = Ticket.create
      event = Stitch::Event::Base.new(:ticket_created, Time.now, ticket: ticket)
      event.compress_data
      event.data[:ticket].should be_nil
      event.data[:ticket_id].should == ticket.id
    end
  end

  context "Expand data" do
    it "should expand ids to their corresponding ActiveRecord Objects in data" do
      ticket = Ticket.create
      event = Stitch::Event::Base.new(:ticket_created, Time.now, ticket: ticket)
      event.compress_data
      event.data[:ticket].should be_nil
      event.expand_data
      event.data[:ticket].class.should == Ticket
    end
  end
end

