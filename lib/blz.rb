# Copyright (C) 2012 Oliver Eilhard
#
# This library is freely distributable under the terms of
# an MIT-style license.
# See COPYING or http://www.opensource.org/licenses/mit-license.php.
#
# Provides information about "Bankleitzahlen" (BLZ),
# a bank identifier code system used by German and Austrian banks.

require "date"

module BLZ
  def self.convert_file_to_date(f)
    match = f.match(/(?<y>\d{4})_(?<m>\d\d)_(?<d>\d\d)\.tsv\.gz$/)
    Date.new match[:y].to_i, match[:m].to_i, match[:d].to_i
  end

  def self.find_data_file(now=Date.today)
    glob = Dir[ File.join(File.dirname(__FILE__), '../data/*.tsv.gz') ].sort
    file = glob.find {|c| now <= convert_file_to_date(c) } || glob.last

    # sanity check
    if now < Date.new(2016, 3, 6) || now > (convert_file_to_date(file) + 90)
      warn [now]
      warn '[BLZ] The data provided may not be accurate.'
    end

    file
  end

  DATA_FILE = find_data_file
end

require 'blz/bank'
