#!/usr/bin/env ruby

require "mechanize"
require "logger"
require "zlib"

if (f = File.expand_path("~/.extranet")) && File.exist?(f)
  username, password = File.read(f).strip.split(":", 2)
else
  username = ENV.fetch("EXTRANET_USERNAME")
  password = ENV.fetch("EXTRANET_PASSWORD")
end

# from ./convert.rb
METRIC = [8, 1, 58, 5, 35, 27, 5, 11, 2, 6, 1, 1, 8]
METRIC_LEN = METRIC.inject(:+)

NAVIGATION = {
  login:  "https://extranet.bundesbank.de/FT/",
  table:  "https://extranet.bundesbank.de/FT/dirHTML.do?dirKind=DOWN&ftclient=browser&tableView=kompakt",
  logout: "https://extranet.bundesbank.de/FT/logout.do",
}

# don't double download already existing files
last = Dir[ File.expand_path('../data/*.tsv.gz', __dir__) ].sort.last
last_match = last.match(/(?<y>\d{4})_(?<m>\d\d)_(?<d>\d\d)\.tsv\.gz$/)

logger = Logger.new($stderr).tap{|l| l.level = Logger::INFO }
agent = Mechanize.new do |m|
  # m.log = logger
  m.user_agent_alias = "Windows IE 11"
  m.pluggable_parser["application/octet-stream"] = Mechanize::Download
end

begin
  logger.info("login")
  page = agent.get NAVIGATION[:login]
  form = page.form_with action: "/pkmslogin.form"
  form["username"] = username
  form["password"] = password
  agent.submit(form)

  logger.info("get list of downloads")
  sleep 1
  page = agent.get NAVIGATION[:table]

  target_link = page.links.find do |link|
    !!(link.text.strip =~ /BLZ_\d{8}.txt/)
  end

  if !target_link
    logger.info("no new download found")
    exit 0
  end

  name = target_link.text.strip
  if name == format("BLZ_%4d%02d%02d.txt", last_match[:y].to_i, last_match[:m].to_i, last_match[:d].to_i)
    logger.info("no matching link found")
    exit 0
  end

  logger.info("downloading new file #{name}")
  sleep 1
  blz = agent.get(target_link.href)

  name_match = name.match(/BLZ_(?<y>\d{4})(?<m>\d\d)(?<d>\d\d)\.txt$/)
  target_name = format("../data/%4d_%02d_%02d.tsv.gz", name_match[:y].to_i, name_match[:m].to_i, name_match[:d].to_i)
  target_file = File.expand_path(target_name, __dir__)

  logger.info("reformatting, saving as #{target_file}")
  Zlib::GzipWriter.open(target_file, Zlib::BEST_COMPRESSION) do |gz|
    while line = blz.body_io.gets
      line = line.encode(Encoding::UTF_8, Encoding::ISO_8859_15).chomp!
      if line.length != METRIC_LEN
        logger.error("expected line length #{METRIC_LEN}, got #{line.length} in '#{line}'")
        next
      end

      i = 0
      gz.puts METRIC.inject([]) {|s, m| s << line[i ... (i+=m)].strip }.join("\t")
    end
  end

  logger.info("suggestion new version: 0.2.0.#{name_match[:y]}#{name_match[:m]}#{name_match[:d]}")
ensure
  logger.info("logout")
  sleep 1
  agent.get NAVIGATION[:logout]
end
