# encoding: utf-8
require 'csv'
require 'zlib'

module BLZ
  class Bank
    #  Represents a bank with a BLZ, a BIC, a name etc.
    class << self
      # Returns an array of all Banks specified by +code+.
      # The following options apply:
      #    exact:: Only return exact matches (false by default)
      #
      def find_by_blz(code, options = {})
        return [] if blank?(code)

        exact = options.fetch(:exact, false)
        all.select do |bank|
          bank.blz == code || (!exact && bank.blz.start_with?(code))
        end
      end

      # Returns an array of all Banks with a substring of +city+.
      def find_by_city(substring)
        return [] if blank?(substring)

        all.select do |bank|
          bank.city.index(substring)
        end
      end

      # Returns an array of all Banks specified by +bic+ (Business Identifier Code).
      # The following options apply:
      #    exact:: Only return exact matches (false by default)
      #
      def find_by_bic(bic, options = {})
        return [] if blank?(bic)

        exact = options.fetch(:exact, false)
        all.select do |bank|
          bank.bic == bic || (!exact && (bank.bic || '').start_with?(bic))
        end
      end

      # Returns an array of all banks.
      def all
        @banks ||= read_banks
      end

      private

      def read_banks
        banks = []
        Zlib::GzipReader.open(BLZ::DATA_FILE) do |gz|
          CSV.new(gz, col_sep: "\t").each do |r|
            banks << new(r[0], r[2], r[3], r[4], r[5], r[7])
          end
        end
        banks
      end

      # Checks whether an object is blank (empty Array/Hash/String).
      #
      # Does not rely on ActiveSupport, but prefers that implementation.
      def blank?(obj)
        return true       if obj.nil?
        return obj.blank? if obj.respond_to?(:blank?)
        obj = obj.strip   if String === obj
        return obj.empty? if obj.respond_to?(:empty?)

        false
      end
    end

    attr_reader :blz, :name, :zip, :city, :short_name, :bic

    # Initializes a single Bank record.
    def initialize(blz, name, zip, city, short_name, bic)
      @blz  = blz
      @name = name
      @zip  = zip
      @city = city
      @bic  = bic
      @short_name = short_name
    end

    # Returns a nice representation of the bank.
    def to_s
      [blz, name, "#{zip} #{city}", bic].compact.reject(&:empty?).join(', ')
    end

  end
end
