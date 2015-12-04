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
  def self.find_data_file(now=Date.today)
    glob = Dir[ File.join(File.dirname(__FILE__), '../data/*.tsv.gz') ].sort

    file2time = proc do |f|
      match = f.match /(?<y>\d{4})_(?<m>\d\d)_(?<d>\d\d)\.tsv\.gz$/
      Date.new match[:y].to_i, match[:m].to_i, match[:d].to_i
    end

    filename = glob.find {|c| now <= file2time[c] } || glob.last

    # sanity check
    t = file2time[filename]
    if t < Date.new(2013, 12, 9) || now > t + 90
      warn '[BLZ] The data provided may not be accurate.'
    end

    filename
  end

  DATA_FILE = find_data_file
end

require 'blz/bank'
