#!/usr/bin/env ruby
#
# Helper to convert an Extranet BLZ file download in a more sane format.
#

if ARGV[0].nil?
  $stderr.puts "Usage: #{$0} FILE|-"
  exit 1
end

# length (and name as comment) of each column
METRIC = [
  8,  # BLZ
  1,  # Merkmal
  58, # Bezeichnung
  5,  # PLZ
  35, # Ort
  27, # Kurzbezeichnung
  5,  # PAN
  11, # BIC
  2,  # Prüfzifferberechnungsmethode
  6,  # Datensatznummer
  1,  # Änderungskennzeichen
  1,  # BLZ-Löschung
  8,  # Nachfolge-BLZ
]

METRIC_LEN = METRIC.inject(:+)

# read from stdin if arg is "-", and setup encoding transformation
SOURCE = (ARGV[0] == "-" ? $stdin : File.open(ARGV[0], "rb"))
  .set_encoding(Encoding::ISO_8859_15, Encoding::UTF_8)

while line = SOURCE.gets
  line.chomp!
  if line.length != METRIC_LEN
    $stderr.puts "expected line length #{METRIC_LEN}, got #{line.length} in '#{line}'"
    next
  end

  i = 0
  puts METRIC.inject([]) {|s, m|
    # extract columns, and strip leading/trailing whitespace
    s << line[i ... (i+=m)].strip
  }.join("\t")
end
