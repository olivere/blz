# encoding: utf-8
require 'csv'

module BLZ
  class Bank
    #  Represents a bank with a BLZ, a BIC, a name etc.
    class << self
      # Returns an array of all Banks specified by +code+.
      # The following options apply:
      #    exact:: Only return exact matches (false by default)
      #
      def find_by_blz(code, options = {})
        exact = options.fetch(:exact, false)
        all.select do |bank|
          bank.blz == code || (!exact && bank.blz.start_with?(code))
        end
      end

      # Returns an array of all Banks with a substring of +city+.
      def find_by_city(substring)
        all.select do |bank|
          bank.city.index(substring)
        end
      end

      # Returns an array of all banks.
      def all
        @banks ||= read_banks
      end
      
      private

      def read_banks
        banks = []
        filename = File.expand_path('data/blz.tsv')
        CSV.foreach(filename, col_sep: "\t") do |r|
          banks << new(r[0], r[2], r[3], r[4], r[5], r[7])
        end
        banks
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
      [blz, name, "#{zip} #{city}", bic].reject(&:empty?).join(', ')
    end
  end
end