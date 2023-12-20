# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Task.create!(title: "Group project guidelines", description: "Need to think of some guidelines for productive group work", category: 2)
Task.create!(title: "Presents?", description: "all the nieces and nephews will need gifts..", category: 1, priority: 1)
Task.create!(title: "Brainstorming session", description: "need new ideas for product launch", category: 0, priority: 2)
Task.create!(title: "Call Vet for Emma's physical", priority: 2)
