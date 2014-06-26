# Copyright (C) 2012 Oliver Eilhard
#
# This library is freely distributable under the terms of
# an MIT-style license.
# See COPYING or http://www.opensource.org/licenses/mit-license.php.
#
# Provides information about "Bankleitzahlen" (BLZ),
# a bank identifier code system used by German and Austrian banks.

module BLZ
  DATA_FILE = begin
    now  = Time.now
    glob = Dir[ File.join(File.dirname(__FILE__), '../data/*.tsv.gz') ].sort

    file2time = proc do |f|
      match = f.match /(?<y>\d{4})_(?<m>\d\d)_(?<d>\d\d)\.tsv\.gz$/
      Time.new match[:y], match[:m], match[:d]
    end

    filename = glob.find {|c| now <= file2time[c] } || glob.last

    # sanity check
    t = file2time[filename]
    if t < Time.new(2013, 12, 9) || now > t + (90 * 24 * 60 * 60)
      warn '[BLZ] The data provided may not be accurate.'
    end

    filename
  end
end

require 'blz/bank'
