require_relative "coercer"
require_relative "validations"

module Form
  # Base form for doing actions based on the attributes specified.
  # This class has to be inherited by different forms, each performing a
  # different action. If needed, #validate method can be overridden if
  # necessary.
  #
  # @example
  #
  #   class LoginForm < Form::Base
  #
  #     attribute :username, String
  #     attribute :password, String
  #
  #     def validate
  #       unless valid_login?
  #         append_error(:username, :invalid_credentials)
  #       end
  #     end
  #
  #     def valid_login?
  #       user = User.where(username: username).first
  #       user && check_password_secure(user.password, password)
  #     end
  #
  #   end
  #
  class Base

    include Validations
    include Coercer

    # Copy parent attributes to inherited class.
    #
    # @param klass [Class]
    def self.inherited(klass)
      super(klass)
      klass.instance_variable_set(:@attributes, attributes.dup)
    end

    # Define an attribute for the form.
    #
    # @param name
    #   The Symbol attribute name.
    # @option options [Class]
    #   The Class of the type of this attribute. Can be any of String, Integer,
    #   Float, Array, Hash or :boolean.
    def self.attribute(name, options = {})
      attr_reader(name) unless options[:skip_reader]
      type = options[:type]
      coercer_method_name = :"coerce_#{type}"

      define_method("#{name}=") do |value|
        if type
          value = send(coercer_method_name, value, options)
        end
        instance_variable_set("@#{name}", value)
      end

      if type
        case type
        when :boolean
          define_method("#{name}?") do
            send(coercer_method_name, send(name), options)
          end
        end
      end

      attributes[name] = options
    end

    # Define the main record of this form (optional).
    #   Record may be called with form_instance.record
    #
    # @param name
    #   The Symbol attribute name.
    # @option options [Class]
    #   The Class of the type of this attribute. Can be any of String, Integer,
    #   Float, Array, Hash or :boolean.
    def self.record(name, options = {})
      define_method(:record) do
        send(name)
      end
      attribute(name, options.merge(:skip => true))
    end

    # Retrieve the list of attributes of the form.
    #
    # @return [Hash]
    #   The class attributes hash.
    def self.attributes
      @attributes ||= {}
    end

    # Initialize a new Form::Base form.
    #
    # @param attrs [Hash]
    #   The attributes values to use for the new instance.
    def initialize(attrs = {})
      set_attributes(attrs)
    end

    # Set the attributes belonging to the form.
    #
    # @param attrs [Hash<String, Object>]
    def set_attributes(attrs)
      return unless attrs.kind_of?(Hash)

      attrs = coerce_hash(attrs, :key_type => :string)

      self.class.attributes.each do |attribute_name, _|
        send("#{attribute_name}=", attrs[attribute_name.to_s])
      end
    end

    # Get the all attributes with its values of the current form.
    #
    # @return [Hash<Symbol, Object>]
    def attributes
      self.class.attributes.each_with_object({}) do |(name, opts), attrs|
        attrs[name] = send(name) unless opts[:skip]
      end
    end

    # Validate and perform the form actions. If any errors come up during the
    # validation or the #perform method, raise an exception with the errors.
    #
    # @raise [Form::ValidationError]
    def perform!
      if valid?
        returned = perform
      end

      if errors.reject{ |k,v| v.empty? }.any?
        raise ValidationError.new(errors)
      end

      returned
    end

  end
end
