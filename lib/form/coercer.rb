module Form
  module Coercer

    # Coerce the value into a String.
    #
    # @param value [Object]
    # @option allow_nil (true)
    #
    # @return [String, nil]
    def coerce_string(value, options = {})
      return nil unless !value.nil? || options[:allow_nil] === false

      value = value.to_s.dup.force_encoding(Encoding::UTF_8)
      options[:upcase] ? value.upcase : value
    end

    # Corce the value into true or false.
    #
    # @param value [Object]
    # @option allow_nil (false)
    #
    # @return [Boolean, nil]
    def coerce_boolean(value, options = {})
      return nil if options[:allow_nil] && value.nil?
      !!value && !coerce_string(value).empty?
    end

    # Coerce the value into an Array.
    #
    # @param value [Object]
    #   The value to be coerced.
    # @option options [Class] :element_type (nil)
    #   The Class type of the value to coerce each element of the array, if nil
    #   no coercion is performed.
    #
    # @return [Array]
    #   The coerced Array.
    def coerce_array(value, options = {})
      element_type = options[:element_type]
      value = value.values if value.kind_of?(Hash)
      if value.kind_of?(Array)
        value.map do |array_element|
          if element_type
            send("coerce_#{element_type}", array_element)
          else
            array_element
          end
        end
      else
        []
      end
    end

    # Coerce the value into a Float.
    #
    # @param value [Object]
    #
    # @return [Float, nil]
    def coerce_float(value, options = {})
      Float(value) rescue nil
    end

    # Coerce the value into an international phone String.
    #
    # @param value [Object]
    #   The value to be coerced.
    #
    # @return [String, nil]
    def coerce_phone(value, options = {})
      value ? coerce_string(value).upcase.gsub(/[^+0-9A-Z]/,'') : nil
    end

    # Coerce the value into a Hash.
    #
    # @param value [Object]
    #   The value to be coerced.
    # @option options :key_type [Class] (nil)
    #   The type of the hash keys to coerce, no coersion if value is nil.
    # @options options :value_type [Class] (nil)
    #   The type of the hash values to coerce, no coersion if value is nil.
    #
    # @return [Hash]
    #   The coerced Hash.
    def coerce_hash(value, options = {})
      key_type = options[:key_type]
      value_type = options[:value_type]
      if value.kind_of?(Hash)
        value.each_with_object({}) do |(key, value), coerced_hash|
          key = send("coerce_#{key_type}", key) if key_type
          value = send("coerce_#{value_type}", value) if value_type
          coerced_hash[key] = value
        end
      else
        {}
      end
    end

    # Coerce the value into an Integer.
    #
    # @param value [Object]
    #   The value to be coerced.
    #
    # @return [Integer, nil]
    #   An Integer if the value can be coerced or nil otherwise.
    def coerce_integer(value, options = {})
      value = value.to_s
      if value.match(/\A0|[1-9]\d*\z/)
        value.to_i
      else
        nil
      end
    end

    # Coerce the value into a Date.
    #
    # @param value [Object]
    #   The value to be coerced.
    #
    # @return [Date, nil]
    #   A Date if the value can be coerced or nil otherwise.
    def coerce_date(value, options = {})
      value = coerce(value, String)
      begin
        Date.strptime(value, "%Y-%m-%d")
      rescue ArgumentError
        nil
      end
    end

    # Coerce the value into a Time.
    #
    # @param value [Object]
    #   The value to be coerced.
    #
    # @return [Time, nil]
    #   A Time if the value can be coerced or nil otherwise.
    def coerce_time(value, options = {})
      value = coerce_string(value, options)
      return nil if !value || value.empty?

      begin
        Time.parse(value)
      rescue ArgumentError
        nil
      end
    end

    # Coerce the value into a File. For the value to be successfully accepted as,
    # it should be a hash containing the :filename (String) and :tempfile
    # (File).
    #
    # @param value [Object]
    #
    # @return [Hash, nil]
    #   The hash will contain the file String :filename and the File :tempfile,
    #   or nil otherwise.
    def coerce_file(value, options = {})
      if value.kind_of?(Hash) && !value[:filename].to_s.empty?
        tempfile = value[:tempfile]
        if tempfile.kind_of?(File) || tempfile.kind_of?(Tempfile)
          value
        end
      end
    end

  end
end
