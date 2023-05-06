require 'net/http'
require 'uri'
require 'json'

# Function to authenticate with the API using the provided identity and password
def auth_with_password(identity, password)
  api_url = "http://127.0.0.1:3422/api/collections/users/auth-with-password"
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

def list_records(token:, collection:, page:, perPage:)
  api_url = "http://127.0.0.1:3422/api/collections/#{collection}/records"
  uri = URI.parse(api_url)
  http = Net::HTTP.new(uri.host, uri.port)
  #http.use_ssl = true

  if page.nil?
    page = 1
    perPage = 100
  end
  request_data = {
    'page' => page,
    'perPage' => perPage
  }.to_json

  request = Net::HTTP::Get.new(uri.request_uri, {'Content-Type' => 'application/json'})
  request['authorization'] = "Basic #{token}"
  request.body = request_data

  response = http.request(request)
  as_object = JSON.parse(response.body, symbolize_names:true)
end

# Example usage
identity = 'tester'
password = 'Testingpass99!'


if File.exists? 'u.auth.json'
  #auth = File.read 'auth.json'
  @auth = JSON.parse(File.read 'u.auth.json', symbolize_names:true)
  puts 'read u.auth.json'
else
  @auth = auth_with_password(identity, password)
  File.write 'u.auth.json', JSON.dump(@auth)
  puts 'created u.auth.json'
end

puts list_records(token: @auth[:token], collection: 'posts', page: 1, perPage: 100)