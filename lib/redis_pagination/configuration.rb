module RedisPagination
  # Configuration settings for redis_pagination.
  module Configuration
    attr_reader :redises
    attr_writer :page_size

    # Yield self to be able to configure redis_pagination with block-style configuration.
    #
    # Example:
    #
    #   RedisPagination.configure do |configuration|
    #     configuration.redis = Redis.new
    #     configuration.page_size = 25
    #     configuration.redises = {
    #         :default => Redis.new
    #     }
    #   end
    def configure
      yield self
    end

    def redises=(redis_obj_hash = {})
      @redises = redis_obj_hash
    end

    def redis(key = :default)
      @redis || @redises[key]
    end

    def redis=(redis_obj)
      @redises ||= {}
      @redises[:default] = @redis = redis_obj
    end
    # Page size to be used when peforming paging operations.
    #
    # @return the page size to be used when peforming paging operations or the default of 25 if not set.
    def page_size
      @page_size ||= 25
    end
  end
end