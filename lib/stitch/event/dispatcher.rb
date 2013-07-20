module Stitch
  module Event
    class Dispatcher
          
      include ActiveModel::Observing

      def self.dispatch(event_name, timestamp, data, async = true)
        event_object = Stitch::Event::Base.new(event_name, timestamp, data)
        if async
          event_object.compress_data
          Resque.enqueue(Stitch::Event::Worker, event_object) if defined?(Resque)
        else
          binding.pry
          notify_observers(event_object.method_name, event_object) 
        end
      end
    end
  end
end

