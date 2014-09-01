module Form
  module Extensions
    module Presenter

      DEFAULT_PER_PAGE = 30
      MAX_PER_PAGE = 100
      SORT_ORDERS = ["ASC", "DESC"]
      DEFAULT_SORT_ORDER = "ASC"

      # Add the attributes to paginate, including :dataset, :page, :sort_by and
      # :sort_order.
      #
      # @param base [Class]
      def self.included(base)

        base.attribute(:dataset)
        base.attribute(:page, :type => :integer, :skip_reader => true)
        base.attribute(:per_page, :type => :integer, :skip_reader => true)
        base.attribute(:sort_by, :type => :string, :skip_reader => true)
        base.attribute(:sort_order, :type => :string, :skip_reader => true)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # Set the attributes in which the collection can be sorted.
        #
        # @param attributes [Array<String>]
        def set_sortable_attributes(attributes)
          @sortable_attributes = attributes
        end

        # Get the attributes in which the collection can be sorted.
        #
        # @return [Array<String>]
        def sortable_attributes
          @sortable_attributes ||= []
        end

        # Set one sortable attribute with options.
        #
        # @return [Array<String>]
        def sortable_attribute(attribute, options = {})
          attribute = attribute.to_s
          sortable_attributes << attribute
          sortable_attributes_options[attribute] = options
        end

        # Retrive the options for a sortable attribute.
        #
        # @return [Hash]
        def sortable_attribute_options(attribute)
          sortable_attributes_options.fetch(attribute.to_s, {})
        end

        # Retrive the sortable_attributes_options.
        #
        # @return [Hash]
        def sortable_attributes_options
          @sortable_attributes_options ||= {}
        end
      end

      # Get a hash of attributes to be used as URL arguments
      #
      # @param attributes [Hash]
      def url_attributes
        @url_attributes ||=
          attributes.except(:dataset).map_values!(&:to_s)
      end

      # Iterate through the results.
      #
      # @param block [Block]
      def each(&block)
        results.each(&block)
      end

      # Set the attributes (override #set_attributes) to include the :filters
      # attributes as regular attributes.
      #
      # @param attrs [Hash]
      def set_attributes(attrs)
        if attrs.has_key?("filters")
          attrs = attrs.merge(attrs["filters"])
        end
        super(attrs)
      end

      # Fetch the total pages of the collection.
      #
      # @return [Integer]
      def total_pages
        @total_pages ||= (count.to_f / per_page).ceil
      end

      def count
        filtered_dataset.count
      end

      def start
        @start ||= (page - 1) * per_page
      end

      # Determine if there are any records.
      #
      # @return [Boolean]
      def any?
        !total_pages.zero?
      end

      # Determine if there results are empty.
      #
      # @return [Boolean]
      def empty?
        total_pages.zero?
      end

      # Get the opposite sort order.
      #
      # @return [String]
      #   "ASC" or "DESC"
      def opposite_sort_order
        sort_order == "ASC" ? "DESC" : "ASC"
      end

      # Determine if the column name is a valid column for this record.
      #
      # @param column_name [String]
      #
      # @return [Boolean]
      def valid_column?(column_name)
        column_name && self.class.sortable_attributes.include?(column_name)
      end

      # Fetch the results for the current page.
      #
      # @return [Array]
      def results
        @results ||= begin
          _dataset = filtered_dataset.limit(per_page).offset(start)

          if sort_by
            options = self.class.sortable_attribute_options(sort_by.to_s)
            order =
              if sort_order == "DESC"
                Sequel.desc(sort_by.to_sym, options)
              else
                Sequel.asc(sort_by.to_sym, options)
              end
            _dataset = _dataset.order(order)
          end

          _dataset.all
        end
      end

      # Get the amound of records per page.
      #
      # @return [Integer]
      def per_page
        if !@per_page || @per_page < 1
          default_per_page
        elsif @per_page > max_per_page
          max_per_page
        else
          @per_page
        end
      end

      # Get the current page.
      #
      # @return [Integer]
      def page
        if !@page || @page < 1
          1
        elsif @page > total_pages
          total_pages
        else
          @page
        end
      end

      # Get the attribute to sort by the records.
      #
      # @return [String]
      def sort_by
        if valid_column?(@sort_by)
          @sort_by
        else
          self.class.sortable_attributes.first
        end
      end

      # Get the order in which to sort the records.
      #
      # @return [String]
      #   "ASC" or "DESC".
      def sort_order
        if @sort_order
          @sort_order.upcase!
          return @sort_order if SORT_ORDERS.include?(@sort_order)
        end
        default_sort_order
      end

      def default_sort_order
        self.class::DEFAULT_SORT_ORDER
      end

      def default_per_page
        self.class::DEFAULT_PER_PAGE
      end

      def max_per_page
        self.class::MAX_PER_PAGE
      end

      # Get the filtered dataset. This has to be overridden to filter according
      # to the form attributes.
      #
      # @return [Sequel::Dataset]
      def filtered_dataset
        dataset
      end

    end
  end
end
