module Stitch
  module Event
    class Base
      attr_accessor :data
      attr_reader :name, :timestamp

      def initialize(name, timestamp, data, compressed=false)
        @name = name
        @data = data.kind_of?(Hash) ? Hashie::Mash.new(data) : data
        @timestamp = timestamp
        @compressed = compressed
      end
    
      def method_name
        name.to_s.gsub('.','_')
      end

      def compressed?
        @compressed
      end

      def compress_data
        return if compressed?
        return unless data.kind_of?(Hash)
        compressed_data = Hashie::Mash.new
        data.each_pair do |key, value|
          if value.respond_to?(:id)
            compressed_data[:"#{key}_id"] = value.id
          else
            compressed_data[key] = value
          end
        end
        @data = compressed_data
        @compressed = true
      end

      def expand_data
        return unless compressed?
        return unless data.kind_of?(Hash)
        expanded_data = Hashie::Mash.new
        data.each_pair do |key, value|
          if key[-3..-1] == "_id"
            new_key = key[0..-4]
            expanded_data[new_key] = new_key.classify.constantize.find(value) rescue nil
          else
            expand_data[key] = value
          end
        end
        @data = expanded_data
        @compressed = false
      end
    end
  end
end
