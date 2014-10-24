require_relative "validation_error"

module Form
  module Validations

    EMAIL_FORMAT = /\A
      ([0-9a-zA-Z\.][-\w\+\.]*)@
      ([0-9a-zA-Z_][-\w]*[0-9a-zA-Z]*\.)+[a-zA-Z]{2,9}\z/x

    ISRC_FORMAT = /\A[a-zA-Z]{2}[a-zA-Z0-9]{5}[0-9]{5}\z/

    # Get the current form errors Hash.
    #
    # @return [Hash<Symbol, Array<Symbol>]
    #   The errors Hash, having the Symbol attribute names as keys and an
    #   array of errors (Symbols) as the value.
    def errors
      @errors ||= Hash.new { |hash, key| hash[key] = [] }
    end

    # Determine if current form instance is valid by running the validations
    # specified on #validate.
    #
    # @return [Boolean]
    def valid?
      errors.clear
      validate
      errors.reject{ |k,v| v.empty? }.empty?
    end

    # Append an error to the given attribute.
    #
    # @param attribute_name [Symbol]
    # @param error [Symbol]
    #   The error identifier.
    def append_error(attribute_name, error)
      errors[attribute_name] << error
    end

    # Validate the presence of the attribute value. If the value is nil or
    # false append the :cant_be_empty error to the attribute.
    #
    # @param attribute_name [Symbol]
    def validate_presence(attribute_name, message = nil)
      value = send(attribute_name)
      if !value || value.to_s.empty?
        append_error(attribute_name, message || :cant_be_empty)
      end
    end

    # Validate the uniqueness of the attribute value. The uniqueness is
    # determined by the block given. If the value is not unique, append the
    # :is_duplicated error to the attribute.
    #
    # @param attribute_name [Symbol]
    # @param block [Proc]
    #   A block to determine if a given value is unique or not. It receives
    #   the value and returns true if the value is unique.
    def validate_uniqueness(attribute_name, message = nil, &block)
      value = attributes[attribute_name]
      unless block.call(value)
        append_error(attribute_name, message || :is_duplicated)
      end
    end

    # Validate the email format. If the value does not match the email format,
    # append the :is_invalid error to the attribute.
    #
    # @param attribute_name [Symbol]
    def validate_email_format(attribute_name, message = nil)
      validate_format(attribute_name, EMAIL_FORMAT, message)
    end

    def validate_isrc_format(attribute_name, message = nil)
      validate_format(attribute_name, ISRC_FORMAT, message)
    end

    # Validate the format of the attribute value. If the value does not match
    # the regexp given, append :is_invalid error to the attribute.
    #
    # @param attribute_name [Symbol]
    # @param format [Regexp]
    def validate_format(attribute_name, format, message = nil)
      value = attributes[attribute_name]
      if value && !(format =~ value)
        append_error(attribute_name, message || :is_invalid)
      end
    end

    # Validate the length of a String, Array or any other form attribute which
    # responds to #size. If the value is too short, append the :too_short
    # error to the attribute. If the value is too long append the :too_long
    # error to the attribute.
    #
    # @param attribute_name [Symbol]
    # @option options [Integer, nil] :min (nil)
    # @option options [Integer, nil] :max (nil)
    def validate_length(attribute_name, options = {})
      min = options.fetch(:min, nil)
      max = options.fetch(:max, nil)
      value = attributes[attribute_name]

      if value
        length = value.size
        if min && length < min
          append_error(attribute_name, options.fetch(:min_message, nil) || :is_too_short)
        end
        if max && length > max
          append_error(attribute_name, options.fetch(:max_message, nil) || :is_too_long)
        end
      end
    end

    # Validate the value of the given attribute is included in the list. If
    # the value is not included in the list, append the :not_listed error to
    # the attribute.
    #
    # @param attribute_name [Symbol]
    # @param list [Array]
    def validate_inclusion(attribute_name, list, message = nil)
      value = attributes[attribute_name]
      if value && !list.include?(value)
        append_error(attribute_name, message || :isnt_listed)
      end
    end

    # Validate the presence of each object in attribute name within list. If the object
    # is not included in the list, append the :not_listed error to the attribute.
    def validate_inclusion_of_each(attribute_name, list, message = nil)
      value = send(attribute_name)
      value && value.each do |obj|
        unless list.include?(obj)
          append_error(value, message || :isnt_listed) 
          break
        end
      end
    end

    # Validate the value of the given attribute is not empty.
    # Appends :cant_be_empty error.
    #
    # @param attribute_name [Symbol]
    def validate_any(attribute_name, message = nil)
      value = attributes[attribute_name]
      if value && value.empty?
        append_error(attribute_name, message || :cant_be_empty)
      end
    end

    # Validate the type of the file sent if included in the list. If it's not,
    # append an :invalid_file error to the attribute.
    #
    # @param attribute_name [Symbol]
    # @param filetypes [Array<String>]
    def validate_filetype(attribute_name, filetypes, message = nil)
      value = send(attribute_name)
      if value && !filetypes.include?(value[:type].to_s.split("/").first)
        append_error(attribute_name, message || :is_invalid)
      end
    end

    # Validate the range in which the attribute can be. If the value is less
    # than the min a :less_than_min error will be appended. If the value is
    # greater than the max a :greater_than_max error will be appended.
    #
    # @param attribute_name [Symbol]
    # @option options [Integer] :min (nil)
    #   The minimum value the attribute can take, if nil, no validation is made.
    # @option options [Integer] :max (nil)
    #   The maximum value the attribute can take, if nil, no validation is made.
    def validate_range(attribute_name, options = {})
      value = send(attribute_name)

      return unless value

      min = options.fetch(:min, nil)
      max = options.fetch(:max, nil)
      append_error(attribute_name, options.fetch(:min_message, nil) || :less_than_min) if min && value < min
      append_error(attribute_name, options.fetch(:max_message, nil) || :greater_than_max) if max && value > max
    end

  end
end
