User.create! name: "Example User",
            email: "example@railstutorial.org",
            password: "123123",
            admin: true

99.times do |n|
  User.create! name: Faker::Name.name,
               email: "example-#{n+1}@railstutorial.org",
               password: 'password'
end
