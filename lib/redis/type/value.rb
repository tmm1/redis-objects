require File.expand_path('../base_object', __FILE__)

class Redis
  module Type
    #
    # Class representing a simple value.  You can use standard Ruby operations on it.
    #
    class Value < BaseObject
      require 'redis/helpers/core_commands'
      include Redis::Helpers::CoreCommands
      require 'redis/helpers/serialize'
      include Redis::Helpers::Serialize

      attr_reader :key, :options, :redis
      def initialize(key, *args)
        super(key, *args)
        @redis.setnx(key, @options[:default]) if @options[:default]
      end

      def value=(val)
        redis.set key, to_redis(val)
      end
      alias_method :set, :value=

        def value
          from_redis redis.get(key)
        end
      alias_method :get, :value

      def to_s;  value.to_s; end
      alias_method :to_str, :to_s

      def ==(x); value == x; end
      def nil?;  value.nil?; end
    end
  end
end
