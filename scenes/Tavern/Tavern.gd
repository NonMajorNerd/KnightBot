extends Node2D

var DEBUG:bool = true

@onready var myAudio = $AudioStreamPlayer2D

#func _ready():
	#for i in range(1, 10):
		#GenerateTavern([])

func GenerateTavern(activeUsers: Array = []):
	
	var returnResult = {}
	
	if not myAudio.playing: myAudio.play()
	#if DEBUG: print("\nGenerating tavern event...")
	#this is a streamer-initiated event which benefits all characters in chat
	
	#we want to generate something along the lines of;
	#Today we're dining in the White Raven Inn. Darth Japer orders the Silverberry Brandy while NonMajor chats with a local.
	
	#format;
	#	[openings] [quality_adjectives] [buildings] [called] The [adjectives] [nouns]. Character [preempt] [result].
	
	var openings = ['We\'re starting our morning in', 'We\'re waking up in', 'We\'re passing time in', 'We\'re spending our evening in',
				'We\'re spending the afternoon at', 'We\'re celebrating a victory in', 'We\'re licking our wounds in', 
				'We\'re planning the next adventure in', 'We\'re checking out',	 'We were recommended', 'We\'re wasting our day in',
				'We\'re counting coins in', 'We\'re discussing our plans in', 'We\'re taking a break at'
					]
	
	var quality_adjectives = ['a run-down', 'a well-kept', 'a fancy', 'a back-alley', 'a nice little', 'a cool, dark', 
							'a musty, cold', 'a quaint', 'a small', 'a packed', 'a massive', 'a huge', 'a stone-carved', 
							'an elegantly-constructed'
							]
	
	var buildings = [ 'tavern', 'inn', 'lodge', 'alehouse', 'taphouse', 'taproom', 'drinkery',
					'alehouse', 'bar room', 'watering hole', 'lounge', 'diner', 'mess hall'
					]
	
	var called = [ 'called', 'named', 'dubbed', 'known as', 'by the name of',
				]
	
	var adjectives = [ 'Yawning', 'Prancing', 'Broken', 'Salty', 'Dapper', 'Shimmering', #first-line adjectives line up with first-line nouns for special names.  
					'Old', 'Dusty', 'Sneaky', 'Grumpy', 'Angry', 'Joyful', 'Weeping', 'Infamous', 'Dreaming', 'Flying', 
					'Dwarven','Gnomish', 'Elven', 'Bard\'s', 'King\'s',
					'Dashing', 'Stout', 'Gallant', 'Stalwart', 'Tenacious', 'Daring', 'Fearless',
					'Red', 'Grey', 'Yellow', 'White', 'Black', 'Golden', 'Copper', 'Emerald', 'Crystal',
					'Earthen', 'Frozen', 'Flaming','Blazing',  'Shining', 'Cursed', 'Blessed', 'Holy'
					]
	
	var nouns = [ 'Portal', 'Pony', 'Staff', 'Seafarer', 'Dragon', 'Mirage', #first-line nouns line up with first-line adjectives for special names.
				'Relic', 'Artifact', 'Song', 'Dance', 'Flagon', 'Chalice', 'Hammer', 'Sword', 'Shield',
				'Fox', 'Raven', 'Crow', 'Dog', 'Cat', 'Hound', 'Goblin', 'Chicken', 'Rooster', 'Hen', 'Squirrel', 'Pig', 'Goat', 'Pheonix'
				]
			
	#descriptors meant to go before the tavern name. includes locations, atmosphere, mood, etc
	var prescriptor = [ "  at the heart of a bustling town", " resting beside a babbling brook", " in a tranquil countryside",
				" perched on a hilltop", " overlooking a sprawling valley", " tucked away within a dense forest", " in a grove of towering trees",
				" at the crossroads", " concealed amidst the craggy peaks", " atop a majestic mountain range", " along the shores of a pristine lake",
				" embraced by rolling hills", " in fields of vibrant wildflowers", " hidden within the labyrinth", " on the streets of an ancient city",
				" nestled within ancient stone walls"," set against a cascading waterfall",	" built into the side of a sheer cliff",
				" sheltered within the ruins of an ancient castle", " anchored by the shores of a bustling harbor"," in the mists of a haunted marshland",
				" built adjacent to a sacred shrine",
				" filled with chatter and laughter", " basking in the warm glow of hearth fires",
				" echoing with the melody of a talented bard", " alive with the scents of meat and spiced ales",
				" brimming with excitement", " radiating a welcoming and comforting ambiance",
				" immersed in the soothing melodies of a wandering minstrel",
				" teeming with hustle and bustle",
				" charged with anticipation",
				" infused with the whispers of untold secrets",
				" - a haven for weary wanderers seeking respite",
				" bathed in the soft glow of flickering candlelight",
				" alive with the spirit of adventure",
				" - a sanctuary from the perils of the outside world",
				" filled with the hum of friendly conversation",
				" - a hub of cultural exchange and diverse encounters",
				" - a magnet for kindred spirits and brave souls"
	]

	var postscriptor = [
		" Exposed wooden beams add a rustic charm. ",
		" Elaborate tapestries depict heroic sagas. ",
		" Stained glass windows cast a kaleidoscope of colors. ",
		" The gleaming hardwood floors are polished to a mirror-like shine. ",
		" A crackling hearth spreads warmth throughout the space. ",
		" The shelves are adorned with books and trinkets from distant lands. ",
		" The hand-carved furniture is decorated with intricate designs. ",
		" A well-stocked bar showcases an impressive array of drinks. ",
		" Cozy nooks with plush cushions invite intimate conversations. ",
		" Elegant chandeliers illuminate the room with a soft glow. ",
		" Paintings depicting legendary battles and mythical creatures adorn the walls. ",
		" Potted plants and fresh flowers add a touch of nature. ",
		" A hidden corner displays a collection of ancient artifacts. ",
		" They offer outdoor seating in a charming courtyard. ",
		" Maps and parchments decorate the walls, hinting at adventure. ",
		" Animal trophies showcase the prowess of local hunters. ",
		" Candles flicker in ornate candle holders. ",
		" Sturdy oak tables and chairs invite lively gatherings. ",
		" Mirrors have been strategically placed to create an illusion of space. ",
		" Banners and flags representing various adventurers' guilds decorate the walls. "
]
				
	var interactions = [ 'Food', 'Drink', 'People', 'Environment']
	
	var foodpre = [ 'is eating something called', 'is picking at', 'ordered something called', 'is regretting asking for', 'is devouring',
				'is loving', 'isn\'t happy with', 'doesn\'t like', 
					]
	
	var food = [ 'the Garden Surprise', 'the Caster\'s Stew', 'the Magister\'s Delight', 'the Rat Ratatouille', 'the Humble Pie', 'acorn soup', 'the Frogs-On-Skewers', 
				'bog-beetle dumplings', 'the Wayfarer\'s Cake', 'the Meerkat on Sage', "'not-that-old' rice", 'a loaf of Grell', 'a shiny roseapple',
				'blackbark soup', 'mintnut cheese', 'mint jelly', 'the brawn tart', 'boiled bebilith', 'the Dream Pastries', 'the Primal Fruit'
				]
	
	var drinkspre = [ 'drinks', 'sips', 'is throwing back', 'is drinking', 'is enjoying', 'is guzzling', 'quaffs', 'is slurping', 'is gulping', 'makes a toast with'
					]
	
	var drinks = [ 'a tall grog', 'Goblin\'s Piss', 'turnip wine', 'a Dwarven ale', 'a Dwarven rum', 'spiced ale', 'ale', 'rice wine', 'Desert Star wine',
				'Lotus leaf wine', 'Fey wine', 'a Frenzywater', 'a Golden Gnome Light', 'a Moonslake', 'berry brandy',
				'goat\'s milk and brandy', 'Swamplight spirits', 'peach wine', 'tangerine brandy', 'fireweed whiskey', 'a Wanderer\'s Whiskey', 
				'Scorpionweed reserve', 'lemon mead', 'moss mead', 'golden mead', 'peach mead', 'honeysuckle mead', 'sundew mead', 'a shadow stein',
				'a Deep ale', 'an algea ale', 'a glittering ale'
				]

	var peoplepre = [ 'is talking to', 'is arm wrestling', 'is doing shots with', 'is arguing with', 'is laughing with', 'is enjoying the company of',
					'seems annoyed with', 'is telling jokes with', 'is smiling with', 'is having a contest with', 'is gambling with', 'is playing cards with',
					'is singing with', 'is playing chess with', 'is showing off to', 'is in a heated discussion with', 'graciously paid the tab of',
					'is talking business with', 'is huddled together, poring over a detailed map with'
					]
	
	var people = [ 'a bearded human', 'a white-haired Dwarf', 'a pale orc', 'a stalky elf', 'a blue-eyed halfling', 'an elderly gnome',
				'an elven bard', 'one of the barmaids', 'the barkeep', 'the owner', 'the boss', 'a rogue at the bar',
				'someone who just walked in', 'someone in the corner', 'someone by the fireplace', 'a hobbit carrying a ring',
				'a nearby table', 'a hooded adventurer', 'a paladin in full plate', 'a grizzled adventurer',
				'one of the guards', 'a friendly innkeeper'
				]
	
	var environment = [ 'is relaxing by the fireplace', 'is sleeping in their room', 'is sorting their bag', 'scribbles in their journal', 'studies an ancient tome',
					'is translating a scroll', 'is decyphering a codex', 'is sharpening their sword', 'is cleaning their armor', 'is carefully concocting potent potions',
					'is carving a wooden figure', 'is petting the resident cat', 'is petting the resident dog'
					]

	var result:String = ""
	var charName:String = "Someone"
	
	# pick a random character name from activeUsers
	if activeUsers.size() > 0: charName = activeUsers.pick_random().characterData["name"]
	
	# pick a random interaction
	var ichoice:String = interactions.pick_random()
	
	#all non-environmental interactions get a bit of preceeding text
	var preempt:String = ''
	if ichoice == 'Food':
		preempt = foodpre.pick_random()
		result = food.pick_random()
		
	elif ichoice == 'Drink':
		preempt = drinkspre.pick_random()
		result = drinks.pick_random()
		
	elif ichoice == 'People':
		preempt = peoplepre.pick_random()
		result = people.pick_random()

	elif ichoice == 'Environment':
		preempt = ""
		result = environment.pick_random()

	var tavernName = adjectives.pick_random() + " " + nouns.pick_random()
	var intro = quality_adjectives.pick_random() + " " + buildings.pick_random()
	
	#check for secret name combos, reward/modify text
	var secret_names = ['Yawning Portal', 'Prancing Pony', 'Broken Staff',
						'Salty Seafarer', 'Dapper Dragon', 'Shimmering Mirage' ]
	var modifier = 1
	if tavernName in secret_names:
		if DEBUG: print('NAME DOUBLE!!')	
		modifier = 2
		tavernName = 'the one and only ' + tavernName
	else:
		tavernName = "The " + tavernName

	#add pre or post descriptors
	var choice = randi_range(0,1)
	var preDescriptor = ""
	var postDescriptor = ""
	if choice == 0:
		preDescriptor = prescriptor.pick_random()
	else:
		postDescriptor = postscriptor.pick_random()
	
	#determine xp reward
	var xp_reward = modifier * (50 + ( 10 * randi_range(0,5) ) )

	var final = openings.pick_random() + " " + intro  + preDescriptor + " " + called.pick_random()  + " " + tavernName + ". " + postDescriptor + charName + " " + preempt + " " +	 result + ". || All characters gain " + str(xp_reward) + "xp!"

	returnResult['xp_reward'] = xp_reward
	returnResult['tavern'] = final

	return returnResult
