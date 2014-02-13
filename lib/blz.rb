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
    now = Time.now

    filename = if now <= Time.new(2013, 12, 9)
      warn '[BLZ] The data provided may not be accurate.'
      '2012_06_04.tsv.gz'
    elsif Time.new(2013, 12, 9) < now && now <= Time.new(2014, 3, 2)
      '2013_12_09.tsv.gz'
    elsif Time.new(2014, 3, 2) < now && now <= Time.new(2014, 6, 8)
      '2014_03_03.tsv.gz'
    else
      warn '[BLZ] The data provided may not be accurate.'
      '2014_03_03.tsv.gz'
    end

    File.join(File.dirname(__FILE__), '../data', filename)
  end
end

require 'blz/bank'
