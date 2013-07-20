module Stitch
  module Event
    class Observer < ActiveModel::Observer
      def self.observed_classes
        [Stitch::Event::Dispatcher]
      end
    end
  end
end
