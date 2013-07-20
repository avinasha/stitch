require 'spec_helper'

describe Stitch::Event::Worker do
  it "should expand data and call notify observers" do
    event_object = Stitch::Event::Base.new(:'ticket.created', Time.now, 0)
    flexmock(event_object).should_receive(:expand_data).once
    flexmock(Stitch::Event::Dispatcher).should_receive(:notify_observers).with('ticket_created', event_object).once
    Stitch::Event::Worker.perform(event_object)
  end
end

