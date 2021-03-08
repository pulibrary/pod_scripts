#!/usr/bin/env ruby

require "date"
require "marc"
require "zlib"

@n = 0
@incl = 0
@skip = 0
records = []

def write_records(records)
  return if records.count == 0
  @n += 1
  fn = "./pod_files_ruby/ruby_%04d.xml" % @n
  puts "#{DateTime.now} writing #{fn}..."
  writer = MARC::XMLWriter.new(File.open(fn, "w"))
  # Needed when using MARC binary
  # writer.allow_oversized = true
  records.each { |r| writer.write(r) }
  writer.close
end

def oclc?(record)
  return record["035"]["a"]&.include?("OCoLC") if record["035"]
  false
end

ARGV.each do |f|
  puts "#{DateTime.now} reading #{f}"
  reader = MARC::XMLReader.new(File.open(f))
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
