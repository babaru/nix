user = User.create(email: 'admin@tida.in', password: '12345678', password_confirmation: '12345678')
puts "Created user: #{user.email}"
