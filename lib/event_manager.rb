require "csv"
require "sunlight/congress"
require "erb"

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

#contents = File.read "event_attendees.csv"
#puts contents

=begin
lines = File.readlines "event_attendees.csv"
  lines.each_with_index do |line, index|
  	next if index == 0
  	columns = line.split(",")
  	name = columns[2]
  	puts name
  end
=end

def clean_zipcode(zipcode)
=begin
  if zipcode.nil?
  	zipcode = "00000"
  elsif zipcode.length < 5
  	zipcode = zipcode.rjust 5, "0"
  elsif zipcode.length > 5
  	zipcode = zipcode[0..4]
  else
  	zipcode
  end
=end

#refactor above code
  zipcode.to_s.rjust(5, "0")[0..4]
end

def legislators_by_zipcode(zipcode)
  Sunlight::Congress::Legislator.by_zipcode(zipcode)

=begin
  legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)
  legislator_names = legislators.collect do |legislator|
    "#{legislator.first_name} #{legislator.last_name}"
  end

  legislators_string = legislator_names.join(", ")

=end
end

def save_thank_you_letters(id, form_letter)
  Dir.mkdir("output") unless Dir.exists? "output"

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
  	file.puts form_letter
  end

end

puts "EventManager initialized!"

# parse through file using Ruby's CSV external library
contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letters(id, form_letter)
  
end
  
  #personal_letter = template_letter.gsub('FIRST_NAME', name)
  #personal_letter.gsub!('LEGISLATORS', legislators)

  puts form_letter

