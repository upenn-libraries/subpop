# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

content_types = [
  "Armorial",
  "Binder's Mark",
  "Binding Stamp",
  "Signature",
  "Gift/Presentation",
  "Monogram",
  "Shelf Mark",
  "Seller's Mark",
  "Sale Record",
  "Price/Purchase Information",
  "Colophon",
  "(De)Accession Mark",
  "Forgery/Copy",
  "Effaced",
  "Bibliographic Note",
  "Stamped Binding"
]

content_types.each do |name|
  ContentType.find_or_create_by name: name
end

names_file = File.expand_path '../POP_Names.txt', __FILE__
if File.exists? names_file
  puts "INFO: Using names file: #{names_file}"
  File.open names_file do |f|
    numlines = f.count
    idx = 0
    f.rewind
    f.each do |name|
      Name.find_or_create_by name: name.strip
      idx += 1
      if idx % 100 == 0
        puts sprintf("INFO: %5d/%d names handled", idx, numlines)
      end
    end
    puts sprintf("INFO: %5d/%d names handled", numlines, numlines)
  end
else
  puts "WARNING: Could not find names file: #{names_file}"
end

puts "INFO: Total count of names in database: #{Name.count}"

ADMIN_USERS = [
  {
    username: 'LauraAy',
    email: 'aydel@upenn.edu',
    full_name: 'Laura Aydelotte',
    admin: true
  },
  {
    username: 'doug',
    email: 'emeryr@upenn.edu',
    full_name: 'Doug Emery',
    admin: true
  }]


ADMIN_USERS.each do |data|
  if User.exists? username: data[:username]
    puts "User already exists: #{data[:username]}"
  else
    pass = SecureRandom.hex
    User.find_or_create_by username: data[:username] do |user|
      user.password              = pass
      user.email                 = data[:email]
      user.full_name             = data[:full_name]
      user.admin                 = data[:admin]
    end

    puts "CREATED User #{data[:username]} with password #{pass}."
  end
end