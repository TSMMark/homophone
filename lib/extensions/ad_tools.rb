class Extensions::AdTools
  # SEQUENCE = %w(horizontal auto) # example sequence
  DEFAULT_FORMAT  = "auto"

  SLOT_DATA = {
    responsive: "4153570663"
  }

  DATA_DEFAULTS = {
    :"class"          => "adsbygoogle",
    :"style"          => "display:block",
    :"data-ad-client" => "ca-pub-7450582029313903"
  }

  def initialize(options={})
    @format_sequence = options[:format_sequence]  ? options[:format_sequence] : nil
    @default_format  = options[:default_format]   ? options[:default_format] : DEFAULT_FORMAT
    
    # if slot is Integer, use that. if string or sym, get from SLOT_DATA
    @slot = 4153570663
  end

  def request_ad_data(type="responsive", options={})
    DATA_DEFAULTS.merge( :"data-ad-format"  => next_ad_type.tap {|t| puts t},
                            :"data-ad-slot" => @slot).merge(options)
  end

  def next_ad_type
    (@format_sequence && @format_sequence[card_ad_count_increment - 1]) || @default_format
  end

  def card_ad_count
    @card_ad_count ||= 0
  end

  def card_ad_count_increment
    @card_ad_count = card_ad_count + 1
  end

end
