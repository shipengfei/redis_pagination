require 'redis_pagination/paginator/list_paginator'
require 'redis_pagination/paginator/none_paginator'
require 'redis_pagination/paginator/sorted_set_paginator'

module RedisPagination
  module Paginator
    # Retrieve a paginator class appropriate for the +key+ in Redis.
    # +key+ must be one of +list+ or +zset+, otherwise an exception 
    # will be raised.
    #
    # @params key [String] Redis key
    # @params options [Hash] Options to be passed to the individual paginator class.
    #
    # @return Returns either a +RedisPagination::Paginator::ListPaginator+ or 
    #   a +RedisPagination::Paginator::SortedSetPaginator+ depending on the 
    #   type of +key+.
    def paginate(key, options = {}, redis_config_key = :default)
      type = RedisPagination.redis(redis_config_key).type(key)

      case type
      when 'list'
        RedisPagination::Paginator::ListPaginator.new(key, options, redis_config_key)
      when 'zset'
        RedisPagination::Paginator::SortedSetPaginator.new(key, options, redis_config_key)
      when 'none'
        RedisPagination::Paginator::NonePaginator.new(key, options, redis_config_key)
      else
        raise "Pagination is not supported for #{type}"
      end
    end
  end
end