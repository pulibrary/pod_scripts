#!/usr/bin/env ruby

# fetch most recent full dump from alma (staging)

require "json"
require "net/http"
require "uri"

def fetch(url)
  Net::HTTP.get_response(URI(url))
end

#events_url = "https://bibdata.princeton.edu/events.json" # voyager/production
events_url = "https://bibdata-alma-staging.princeton.edu/events.json" # alma/staging

# fetch list of events and get most recent full dump
events = JSON.parse(fetch(events_url).body)
full = events.select { |e| e["dump_type"] == "ALL_RECORDS" }
latest = full.sort { |a, b| b["finish"] <=> a["finish"] }.first
latest_dump_time = latest['finish']
latest_dump_url = latest['dump_url']
puts "latest dump: #{latest_dump_time}, #{latest_dump_url}"

# retrieve each file and save to disk
dump_info = JSON.parse(fetch(latest_dump_url).body)
file_urls = dump_info["files"]["bib_records"].map { |df| df["dump_file"] }
file_urls.each do |u|
  puts u
  response = fetch(u)
  fn = u.gsub(/.*\//, "")
  File.open("bibdata/alma_#{fn}.tar.gz", "w") do |f|
    f.print(response.body)
  end
end
