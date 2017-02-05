# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Item.create!(title: 'Funny Face',
  description: 'ink on board',
  width: 7.50,
  height: 4.50, 
  lister_id: 1,
  email: 'lolarabbit@gmail.com',
  img_loc: '/assets/funny_face.png', 
  img_sml_loc: '/assets/funny_face_sml.png')

Item.create!(title: 'Funky Hair',
  description: 'ink on board',
  width: 3.75,
  height: 3.50, 
  lister_id: 2,
  email: 'davebear@gmail.com',
  img_loc: '/assets/funky_hair.png', 
  img_sml_loc: '/assets/funky_hair_sml.png')