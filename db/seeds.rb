# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = %w(action drama comedy)

categories.each {|category| Category.create(title: category)}

video = Video.create(title:'Die Hard',
             description:'The Die Hard series is a series of action movies beginning with Die Hard in 1988, based on the 1979 best-selling novel Nothing Lasts Forever by Roderick Thorp.',
             small_cover_url: '/video_images/die_hard_s.jpg',
             large_cover_url: '/video_images/die_hard_l.jpg')
video.categories << Category.find_by(title: 'action')
video = Video.create(title:'Se7en',
            description:'When retiring police Detective William Somerset (Morgan Freeman) tackles a final case with the aid of newly transferred David Mills (Brad Pitt), they discover a number of elaborate and grizzly murders. They soon realize they are dealing with a serial killer (Kevin Spacey) who is targeting people he thinks represent one of the seven deadly sins. Somerset also befriends Mills\' wife, Tracy (Gwyneth Paltrow), who is pregnant and afraid to raise her child in the crime-riddled city.',
            small_cover_url: '/video_images/se7en_s.jpg',
            large_cover_url: '/video_images/se7en_l.jpg')
video.categories << Category.find_by(title: 'drama')
video = Video.create(title:'The God Father',
             description:'Widely regarded as one of the greatest films of all time, this mob drama, based on Mario Puzo\'s novel of the same name, focuses on the powerful Italian-American crime family of Don Vito Corleone (Marlon Brando). When the don\'s youngest son, Michael (Al Pacino), reluctantly joins the Mafia, he becomes involved in the inevitable cycle of violence and betrayal. Although Michael tries to maintain a normal relationship with his wife, Kay (Diane Keaton), he is drawn deeper into the family business.',
             small_cover_url: '/video_images/the_god_father_s.jpg',
             large_cover_url: '/video_images/the_god_father_l.jpg')
video.categories << Category.find_by(title: 'drama')
video = Video.create(title:'The Intern',
             description:'Starting a new job can be a difficult challenge, especially if you\'re already retired. Looking to get back into the game, 70-year-old widower Ben Whittaker (Robert De Niro) seizes the opportunity to become a senior intern at an online fashion site. Ben soon becomes popular with his younger co-workers, including Jules Ostin (Anne Hathaway), the boss and founder of the company. Whittaker\'s charm, wisdom and sense of humor help him develop a special bond and growing friendship with Jules.',
             small_cover_url: '/video_images/the_intern_s.jpg',
             large_cover_url: '/video_images/the_intern_l.jpg')
video.categories << Category.find_by(title: 'comedy')
video = Video.create(title:'The Matrix',
             description:'Neo (Keanu Reeves) believes that Morpheus (Laurence Fishburne), an elusive figure considered to be the most dangerous man alive, can answer his question -- What is the Matrix? Neo is contacted by Trinity (Carrie-Anne Moss), a beautiful stranger who leads him into an underworld where he meets Morpheus. They fight a brutal battle for their lives against a cadre of viciously intelligent secret agents. It is a truth that could cost Neo something more precious than his life.',
             small_cover_url: '/video_images/the_matrix_s.jpg',
             large_cover_url: '/video_images/the_matrix_l.jpg')
video.categories << Category.find_by(title: 'drama')
video = Video.create(title:'Up',
             description:'Carl Fredricksen (Ed Asner), a 78-year-old balloon salesman, is about to fulfill a lifelong dream. Tying thousands of balloons to his house, he flies away to the South American wilderness. But curmudgeonly Carl\'s worst nightmare comes true when he discovers a little boy named Russell is a stowaway aboard the balloon-powered house.',
             small_cover_url: '/video_images/up_s.jpg',
             large_cover_url: '/video_images/up_l.jpg')
video.categories << Category.find_by(title: 'comedy')
video = Video.create(title:'The Matrix',
             description:'Neo (Keanu Reeves) believes that Morpheus (Laurence Fishburne), an elusive figure considered to be the most dangerous man alive, can answer his question -- What is the Matrix? Neo is contacted by Trinity (Carrie-Anne Moss), a beautiful stranger who leads him into an underworld where he meets Morpheus. They fight a brutal battle for their lives against a cadre of viciously intelligent secret agents. It is a truth that could cost Neo something more precious than his life.',
             small_cover_url: '/video_images/the_matrix_s.jpg',
             large_cover_url: '/video_images/the_matrix_l.jpg')
video.categories << Category.find_by(title: 'drama')
video = Video.create(title:'Se7en',
            description:'When retiring police Detective William Somerset (Morgan Freeman) tackles a final case with the aid of newly transferred David Mills (Brad Pitt), they discover a number of elaborate and grizzly murders. They soon realize they are dealing with a serial killer (Kevin Spacey) who is targeting people he thinks represent one of the seven deadly sins. Somerset also befriends Mills\' wife, Tracy (Gwyneth Paltrow), who is pregnant and afraid to raise her child in the crime-riddled city.',
            small_cover_url: '/video_images/se7en_s.jpg',
            large_cover_url: '/video_images/se7en_l.jpg')
video.categories << Category.find_by(title: 'drama')
video = Video.create(title:'The God Father',
             description:'Widely regarded as one of the greatest films of all time, this mob drama, based on Mario Puzo\'s novel of the same name, focuses on the powerful Italian-American crime family of Don Vito Corleone (Marlon Brando). When the don\'s youngest son, Michael (Al Pacino), reluctantly joins the Mafia, he becomes involved in the inevitable cycle of violence and betrayal. Although Michael tries to maintain a normal relationship with his wife, Kay (Diane Keaton), he is drawn deeper into the family business.',
             small_cover_url: '/video_images/the_god_father_s.jpg',
             large_cover_url: '/video_images/the_god_father_l.jpg')
video.categories << Category.find_by(title: 'drama')
video = Video.create(title:'Se7en',
            description:'When retiring police Detective William Somerset (Morgan Freeman) tackles a final case with the aid of newly transferred David Mills (Brad Pitt), they discover a number of elaborate and grizzly murders. They soon realize they are dealing with a serial killer (Kevin Spacey) who is targeting people he thinks represent one of the seven deadly sins. Somerset also befriends Mills\' wife, Tracy (Gwyneth Paltrow), who is pregnant and afraid to raise her child in the crime-riddled city.',
            small_cover_url: '/video_images/se7en_s.jpg',
            large_cover_url: '/video_images/se7en_l.jpg')
video.categories << Category.find_by(title: 'drama')
video = Video.create(title:'The God Father',
             description:'Widely regarded as one of the greatest films of all time, this mob drama, based on Mario Puzo\'s novel of the same name, focuses on the powerful Italian-American crime family of Don Vito Corleone (Marlon Brando). When the don\'s youngest son, Michael (Al Pacino), reluctantly joins the Mafia, he becomes involved in the inevitable cycle of violence and betrayal. Although Michael tries to maintain a normal relationship with his wife, Kay (Diane Keaton), he is drawn deeper into the family business.',
             small_cover_url: '/video_images/the_god_father_s.jpg',
             large_cover_url: '/video_images/the_god_father_l.jpg')
video.categories << Category.find_by(title: 'drama')
