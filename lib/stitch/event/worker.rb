module Stitch
  module Event
    class Worker
      def self.perform(event)
        event_object = event.kind_of?(Stitch::Event::Base) ? event :  Stitch::Event::Base.new(event['name'], Time.parse(event['timestamp']), event['data'], event['compressed'])
        event_object.expand_data
        Stitch::Event::Dispatcher.notify_observers(event_object.method_name, event_object)
      end
    end
  end
end

