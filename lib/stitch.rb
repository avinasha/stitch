require 'hashie/mash'
require "stitch/version"
require "stitch/event/base"
require "stitch/event/dispatcher"
require "stitch/event/worker"
require "stitch/event/observer"


module Stitch
  module ActiveRecord
    def self.included(base)
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
    end

    module ClassMethods
      def trigger_event(event_name, callback, data = {}, timestamp = Time.now)
        define_dispatcher_method(event_name, data, timestamp, false)
        setup_callback(event_name, callback)
      end

      def trigger_async_event(event_name, callback, data = {}, timestamp = Time.now)
        define_dispatcher_method(event_name, data, timestamp)
        setup_callback(event_name, callback)
      end

      private

      def generate_dispatcher_method_name(event_name)
        event_name = event_name.to_s.gsub(/[^0-9A-Za-z_]/, '_')
        "dispatch_#{event_name}"
      end

      def define_dispatcher_method(event_name, data, timestamp, async = true)
        dispatch_method = generate_dispatcher_method_name(event_name)
        define_method(dispatch_method) do
          dispatch_stitch_event(event_name, timestamp, data, async)
        end
      end

      def setup_callback(event_name, callback)
        dispatch_method = generate_dispatcher_method_name(event_name)
        callback_name = callback
        callback_options = {}

        if callback.is_a?(Hash)
          callback_name, callback_options = callback.shift
        end

        self.send(callback_name, dispatch_method)
      end
    end

    module InstanceMethods
      def dispatch_stitch_event(event_name, timestamp, data, async=true)
        Stitch::Event::Dispatcher.dispatch(event_name, timestamp, data, async)
      end
    end
  end

  if defined?(::ActiveRecord)
    ::ActiveRecord::Base.send(:include, Stitch::ActiveRecord)
  end
end
