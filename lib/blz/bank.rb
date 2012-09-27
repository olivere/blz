# encoding: utf-8

module BLZ
  #  Represents a bank with a BLZ, a BIC, a name etc.
  class Bank
    # BLZ = a bank idenfier code widely used in DE and AT
    attr_reader :blz
    # Name of the bank
    attr_reader :name
    # Postal code
    attr_reader :zip
    # City
    attr_reader :city
    # Short name = short description of the bank
    attr_reader :short_name
    # BIC = bank identifier code (ISO 9362)
    attr_reader :bic

    # Initializes a single Bank record.
    def initialize(blz, name, zip, city, short_name, bic)
      @blz = blz
      @name = name 
      @zip = zip
      @city = city
      @short_name = short_name
      @bic = bic
    end

    # Returns an array of all Banks specified by +code+.
    # The following options apply:
    #
    #    exact:: Only return exact matches (false by default)
    #
    def self.find_by_blz(code, options = nil)
      options ||= {}
      exact = options.fetch(:exact, false)

      self.all.inject([]) do |results, bank|
        if bank.blz == code || (!exact && bank.blz.start_with?(code))
          results << bank
        end
        results
      end
    end

    # Returns an array of all Banks with a substring of +city+.
    def self.find_by_city(substring)
      self.all.inject([]) do |results, bank|
        results << bank if bank.city.index(substring)
        results
      end
    end

    # Returns an array of all banks.
    def self.all
      # TODO is this the right way to do it?
      Thread.current[:'BLZ::Bank.all'] ||= read_banks
    end

    # Returns a nice representation of the bank.
    def to_s
      [blz, name, "#{zip} #{city}", bic].reject { |s| s.empty? }.join ", "
    end

  private

    def self.read_banks
      banks = []
      filename = File.join(File.dirname(__FILE__), '..', '..', 'data', 'blz.tsv')
      File.foreach(filename) do |line|
        columns = line.split /\t/
        blz = columns[0].strip
        name = columns[2].strip
        zip = columns[3].strip
        city = columns[4].strip
        short_name = columns[5].strip
        bic = columns[7].strip
        banks << Bank.new(blz, name, zip, city, short_name, bic)
      end
      banks
    end

  end
end

