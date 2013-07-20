require 'spec_helper'

describe Stitch::Event::Dispatcher do
  describe "::dispatch" do
    context "Async true" do
      it "should compress event data and call resque worker" do
        event_object = Stitch::Event::Base.new(:ticket_created, Time.now, {})
        flexmock(event_object).should_receive(:compress_data).once
        flexmock(Stitch::Event::Base).should_receive(:new).once.and_return(event_object)
        flexmock(Resque).should_receive(:enqueue).with(Stitch::Event::Worker, Stitch::Event::Base).once
        Stitch::Event::Dispatcher.dispatch(:'ticket.created', Time.now, {})
      end
    end

    context "Async false" do
      it "should call notify obsevers" do
        flexmock(Stitch::Event::Dispatcher).should_receive(:notify_observers).with('ticket_created', Stitch::Event::Base).once
        Stitch::Event::Dispatcher.dispatch(:'ticket.created', Time.now, {}, false)
      end
    end
  end
end

