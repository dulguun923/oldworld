# Seed data for verification

User.destroy_all
Tag.destroy_all

# Create Users
user1 = User.create!(username: "alice", email: "alice@example.com", password: "password")
user2 = User.create!(username: "bob", email: "bob@example.com", password: "password")

# Create Tags
tech = Tag.create!(name: "tech")
rails = Tag.create!(name: "rails")
ruby = Tag.create!(name: "ruby")
life = Tag.create!(name: "life")

# Create Posts
p1 = Post.create!(title: "Rails 8 is coming", body: "Check out the new features in Rails 8. It's amazing!", user: user1)
p1.tags << [tech, rails, ruby]

p2 = Post.create!(title: "My Hiking Trip", body: "I went to the mountains last weekend.", user: user2)
p2.tags << [life]

p3 = Post.create!(title: "Why Ruby is great", body: "Ruby is a programmer's best friend via happiness.", user: user1)
p3.tags << [ruby, tech]

p4 = Post.create!(title: "Tech Trends 2025", body: "AI and Quantum computing are taking over.", user: user2)
p4.tags << [tech]

puts "Seeded #{Post.count} posts, #{Tag.count} tags, and #{User.count} users."
