#!/usr/bin/env ruby

require "date"
require "marc"
require "zlib"

@n = 0
@incl = 0
@skip = 0
records = []

def write_records(records)
  @n += 1
  fn = "ruby/ruby_%04d.mrc.gz" % @n
  puts "#{DateTime.now} writing #{fn}..."
  writer = MARC::Writer.new(Zlib::GzipWriter.new(File.open(fn, "w")))
  writer.allow_oversized = true
  records.each { |r| writer.write(r) }
  writer.close
end

def oclc?(record)
  return record["035"]["a"]&.include?("OCoLC") if record["035"]
  false
end

ARGV.each do |f|
  puts "#{DateTime.now} reading #{f}"
  reader = MARC::XMLReader.new(Zlib::GzipReader.open(f))
  reader.each do |record|
    if oclc?(record)
      record.fields("583").each { |priv| record.fields.delete(priv) }
      records << record
      @incl += 1
    else
      @skip += 1
    end
    if records.size == 50_000
      write_records(records)
      records = []
    end
  end
end

write_records(records)
puts "#{DateTime.now} done, #{@incl} records exported, #{@skip} skipped"
