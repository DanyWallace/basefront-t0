require 'net/http'
require 'uri'
require 'json'

# Function to authenticate with the API using the provided identity and password
def auth_with_password(identity, password)
  api_url = "http://wii.index.keyfront.net:8090/api/collections/users/auth-with-password"
  uri = URI.parse(api_url)
  http = Net::HTTP.new(uri.host, uri.port)
  #http.use_ssl = true

  request_data = {
    'identity' => identity,
    'password' => password
  }.to_json

  request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type' => 'application/json'})
  request.body = request_data

  response = http.request(request)
  as_object = JSON.parse(response.body, symbolize_names:true)
end

def list_records(token, page=1, perPage=50)
  api_url = "http://wii.index.keyfront.net:8090/api/collections/tickets/records"
  uri = URI.parse(api_url)
  http = Net::HTTP.new(uri.host, uri.port)
  #http.use_ssl = true

  request_data = {
    'page' => page,
    'perPage' => perPage
  }.to_json

  request = Net::HTTP::Get.new(uri.request_uri, {'Content-Type' => 'application/json'})
  request['authorization'] = "Admin #{token}"
  request.body = request_data

  response = http.request(request)
  as_object = JSON.parse(response.body, symbolize_names:true)
end

# Example usage
identity = 'tester'
password = 'Testingpass99!'

@auth = auth_with_password(identity, password)

if File.exists? 'a.auth.json'
  #auth = File.read 'auth.json'
  @auth = JSON.parse(File.read 'a.auth.json', symbolize_names:true)
  puts 'read a.auth.json'
else
  File.write 'u.auth.json', JSON.dump(@auth)
  puts 'created a.auth.json'
end

puts list_records(@auth[:token])