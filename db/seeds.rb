require 'faker'
require 'open-uri'

puts "Cleaning database..."

ProductCategory.destroy_all
Product.destroy_all
Category.destroy_all
Province.destroy_all

# =========================
# PROVINCES (TAXES)
# =========================
puts "Creating provinces..."

provinces = [
  { name: "Alberta", abbreviation: "AB", gst_rate: 5, pst_rate: 0, hst_rate: 0 },
  { name: "British Columbia", abbreviation: "BC", gst_rate: 5, pst_rate: 7, hst_rate: 0 },
  { name: "Manitoba", abbreviation: "MB", gst_rate: 5, pst_rate: 7, hst_rate: 0 },
  { name: "New Brunswick", abbreviation: "NB", gst_rate: 0, pst_rate: 0, hst_rate: 15 },
  { name: "Newfoundland and Labrador", abbreviation: "NL", gst_rate: 0, pst_rate: 0, hst_rate: 15 },
  { name: "Northwest Territories", abbreviation: "NT", gst_rate: 5, pst_rate: 0, hst_rate: 0 },
  { name: "Nova Scotia", abbreviation: "NS", gst_rate: 0, pst_rate: 0, hst_rate: 15 },
  { name: "Nunavut", abbreviation: "NU", gst_rate: 5, pst_rate: 0, hst_rate: 0 },
  { name: "Ontario", abbreviation: "ON", gst_rate: 0, pst_rate: 0, hst_rate: 13 },
  { name: "Prince Edward Island", abbreviation: "PE", gst_rate: 0, pst_rate: 0, hst_rate: 15 },
  { name: "Quebec", abbreviation: "QC", gst_rate: 5, pst_rate: 9.975, hst_rate: 0 },
  { name: "Saskatchewan", abbreviation: "SK", gst_rate: 5, pst_rate: 6, hst_rate: 0 },
  { name: "Yukon", abbreviation: "YT", gst_rate: 5, pst_rate: 0, hst_rate: 0 }
]

provinces.each { |p| Province.create!(p) }

# =========================
# CATEGORIES
# =========================
puts "Creating categories..."

categories = [
  Category.create!(name: "Clothing and Apparel", description: "Clothing collection"),
  Category.create!(name: "Accessories", description: "Accessories collection"),
  Category.create!(name: "Home Goods", description: "Home items"),
  Category.create!(name: "Kids and Gifts", description: "Kids and gifts")
]

# =========================
# PAGES (ABOUT / CONTACT)
# =========================
puts "Creating pages..."

Page.find_or_create_by!(slug: 'about') do |p|
  p.title = 'About Prairie Threads'
  p.body = 'Prairie Threads is a Winnipeg-based clothing and lifestyle shop focused on modern prairie style.'
end

Page.find_or_create_by!(slug: 'contact') do |p|
  p.title = 'Contact Us'
  p.body = 'Visit us in Winnipeg or contact us for any questions about our products.'
end

# =========================
# PRODUCTS (200 WITH IMAGES)
# =========================
puts "Creating 200 products with images..."

200.times do |i|
  product = Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph(sentence_count: 3),
    price: rand(20.0..150.0).round(2),
    stock_quantity: rand(5..50),
    on_sale: [ true, false ].sample,
    sale_price: rand(10.0..100.0).round(2)
  )

  # assign category
  ProductCategory.create!(
    product: product,
    category: categories.sample
  )

  # attach image
  begin
    file = URI.open("https://picsum.photos/300?random=#{i}")
    product.image.attach(
      io: file,
      filename: "product_#{i}.jpg",
      content_type: "image/jpeg"
    )
  rescue
    puts "Image failed for product #{i}"
  end
end

# =========================
# ADMIN USER
# =========================
puts "Creating admin user..."

AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
  admin.password = 'password'
  admin.password_confirmation = 'password'
end
puts "✅ SEEDING COMPLETE!"

require 'open-uri'
require 'json'
require 'faker'

puts "Fetching API images..."

url = "https://dog.ceo/api/breeds/image/random/20"
data = JSON.parse(URI.open(url).read)

data["message"].each do |img_url|
  product = Product.create!(
    name: Faker::Commerce.product_name,
    description: "Imported product using external API image",
    price: rand(20.0..100.0),
    stock_quantity: rand(5..30),
    on_sale: [ true, false ].sample,
    sale_price: rand(10.0..80.0)
  )

  ProductCategory.create!(
    product: product,
    category: Category.all.sample
  )

  begin
    file = URI.open(img_url)
    product.image.attach(
      io: file,
      filename: "api_product.jpg",
      content_type: "image/jpeg"
    )
  rescue
    puts "Image failed"
  end
end

puts "✅ API products added!"
