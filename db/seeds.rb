# Create a new post with the Rails Wasm logo in it.

post = Post.create!(title: "Rails on Wasm", body: "Welcome to Rails on Wasm!", date: Time.zone.now)
post.cover.attach(io: File.open(Rails.root.join("app/assets/images/rails-on-wasm.png")),
filename: "rails-on-wasm.png")
