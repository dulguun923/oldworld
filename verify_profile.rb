require 'net/http'
require 'json'
require 'uri'

BASE_URL = 'http://localhost:3000'

def request(method, path, body = nil, token = nil)
  uri = URI("#{BASE_URL}#{path}")
  http = Net::HTTP.new(uri.host, uri.port)
  
  if method == :get
    req = Net::HTTP::Get.new(uri)
  elsif method == :post
    req = Net::HTTP::Post.new(uri)
  elsif method == :patch
    req = Net::HTTP::Patch.new(uri)
  end

  req['Content-Type'] = 'application/json'
  req['Authorization'] = "Bearer #{token}" if token
  req.body = body.to_json if body

  http.request(req)
end

# 1. Register
username = "testuser_#{Time.now.to_i}"
email = "#{username}@example.com"
password = "password"
puts "Registering #{username}..."
res = request(:post, '/register', { username: username, email: email, password: password })
puts "Register Response: #{res.code} #{res.body}"
if res.code != '200'
  puts "Failed to register"
  exit
end
data = JSON.parse(res.body)
token = data['token']
user_id = data['user']['id']

# 2. Update Profile
puts "\nUpdating Profile..."
new_bio = "Hello, this is my bio!"
new_avatar = "http://example.com/avatar.png"
res = request(:patch, '/me', { bio: new_bio, avatar_url: new_avatar }, token)
puts "Update Response: #{res.code} #{res.body}"
data = JSON.parse(res.body)
if data['bio'] == new_bio && data['avatar_url'] == new_avatar
  puts "SUCCESS: Profile updated"
else
  puts "FAILURE: Profile not updated correctly"
end

# 3. Get Public Profile
puts "\nGetting Public Profile for ID #{user_id}..."
res = request(:get, "/users/#{user_id}")
puts "Show Response: #{res.code} #{res.body}"
data = JSON.parse(res.body)
if data['username'] == username && data['bio'] == new_bio
  puts "SUCCESS: Public profile verified"
else
  puts "FAILURE: Public profile mismatch"
end
