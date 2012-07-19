module RedisPagination
  module Paginator
    class SortedSetPaginator
      # Initialize a new instance with a given Redis +key+ and options.
      #
      # @param key [String] Redis list key.
      # @param options [Hash] Options for paginator.
      def initialize(key, options = {})
        @key = key
      end

      # Return the total number of pages for +key+.
      #
      # @param page_size [int] Page size to calculate total number of pages.
      # 
      # @return the total number of pages for +key+.
      def total_pages(page_size = RedisPagination.page_size)
        (RedisPagination.redis.zcard(@key) / page_size.to_f).ceil
      end

      # Return the total number of items for +key+.
      #
      # @return the total number of items for +key+.
      def total_items
        RedisPagination.redis.zcard(@key)
      end

      # Retrieve a page of items for +key+.
      #
      # @param page [int] Page of items to retrieve.
      # @param options [Hash] Options. Valid options are :with_scores and :reverse.
      #   :with_scores controls whether the score is returned along with the item. Default is +true+.
      #   :reverse controls whether to return items in highest-to-lowest (+true+) or loweest-to-highest order (+false+). Default is +true+.
      #
      # @return a +Hash+ containing +:current_page+, +:total_pages+, +:total_items+ and +:items+.
      def page(page, options = {})
        current_page = page < 1 ? 1 : page
        index_for_redis = current_page - 1
        starting_offset = index_for_redis * RedisPagination.page_size
        ending_offset = (starting_offset + RedisPagination.page_size) - 1

        with_scores = options.has_key?(:with_scores) ? options[:with_scores] : true
        reverse = options.has_key?(:reverse) ? options[:reverse] : true

        {
          :current_page => current_page,
          :total_pages => total_pages,
          :total_items => total_items,
          :items => if reverse
            RedisPagination.redis.zrevrange(@key, starting_offset, ending_offset, :with_scores => with_scores)
          else
            RedisPagination.redis.zrange(@key, starting_offset, ending_offset, :with_scores => with_scores)
          end
        } 
      end
    end
  end
end