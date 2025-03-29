extends Node2D

var DEBUG:bool = true

var optsCategory:Array = ['Anglo-Saxon', 'Cornish', 'Medieval English']
var optsElements:Array = [1, 2]
var optsGender:Array = ['M', 'F']

var namesAS1:Array = ['Acca', 'Aeaba', 'Aeffa', 'Aeldra', 'Aelfa', 'Aelle', 'Aette',
						'Anna', 'Bass', 'Beda', 'Bica', 'Binni', 'Blacey', 'Blithe', 'Bliths', 'Blostm',
						'Bondi', 'Botta', 'Brand', 'Brant', 'Budda', 'Bugge', 'Bynni', 'Cada', 'Cana',
						'Cearl', 'Cille', 'Clac', 'Cola', 'Cutha','Cyppe','Denu','Dodda','Eabae','Eafa',
						'Eni','Fearn','Freca','Gal','Geol','Goda','Grim','Hacca','Haele','Haki','Hasta',
						'Hedde','Hengist','Horsa','Hrafn','Hring','Hugi','Ine','Lilla','Moll','Mul',
						'Octa','Offa','Ogga','Orm','Peada','Penda','Praen','Pymma','Reod','Saba','Sebbi',
						'Snel','Sped','Swan','Swein','Thearle','Tofi','Toki','Tole','Tripp','Tubbi',
						'Tukka','Tunni','Wace','Wada','Waed','Warer','Wini','Witta','Wuffa','Yffi']

var namesAS2M1:Array = ['Ac','Aelf','Aenes','Aethel','Aew','Ard','Arm','Baerh',
						'Barda','Bay','Beald','Bel','Beo','Beorht','Beorn','Beran','Bitan','Blac','Blaec',
						'Blaed','Bland','Bote','Bregu','Brun','Burg','Cadda','Caed','Cen','Ceol','Cuic',
						'Cuth','Cyne','Daeg','Daegel','Daegga','Deal','Deor','Dern','Dude','Dun','Ead',
						'Eald','Ealh','Ean','Ear','Ecg','Eofor','Frea','Frith','Gar','Geat','Gisel','Glaed',
						'God','Gold','Graeg','Grim','Guth','Halig','Hard','Hari','Heah','Heana','Heard',
						'Heathu','Helm','Heort','Here','Herle','Hlot','Hoga','Holen','Hrof','Hroth','Hun',
						'Hwit','In','Isen','Kettil','Lang','Leod','Leof','Mael','Maer','Maht','Mund','North',
						'Noth','Oe','Ondes','Ord','Orme','Os','Rand','Raegen','Read','Ric','Rim','Ruh',
						'Run','Sa','Sae','Scroc','Secg','Sel','Sig','Sige','Snel','Stan','Strang','Sunu',
						'Swet','Swith','Theod','Thur','Tila','Tort','Treuwe','Trum','Wacer','Waer','Wald',
						'Walt','Weald','Weard','Wict','Wig','Wil','Wine','Wulf','Wusc']

var namesAS2M2:Array = ['aeldra','aesc','arm','beald','beorht','beorn','bert',
						'bote','brand','cromb','cyne','deal','deor','dreda','ecg','eofer','frea','frith',
						'fugol','gar','gard','geat','gild','glaed','god','gold','grim','gyr','haele',
						'hard','heah','heard','helm','here','hun','in','kettil','lac','leod','leof',
						'mael','maer','maht','mann','mon','mund','noth','nyd','raed','rand','ric','rim',
						'run','sele','sig','sige','snel','son','stan','sterre','strang','sunu','swith',
						'thorne','uald','wacer','waer','wald','walh','walt','weald','weard','weorth',
						'wict','wig','wil','wine','wini','wise','wold','wulf','wyn']

var namesAS2F1:Array = ['Ac','Aelf','Aenes','Aethel','Aew','Ard','Arm','Baerh',
						'Barda','Bay','Beald','Bel','Beo','Beorht','Beorn','Beran','Bitan','Blac','Blaec','Blaed',
						'Bland','Bote','Bregu','Brun','Burg','Cadda','Caed','Cen','Ceol','Cuic','Cuth','Cwen',
						'Cyne','Daeg','Daegel','Daegga','Deal','Deor','Dern','Dude','Dun','Ead','Eald','Ealh',
						'Ean','Ear','Ecg','Eofor','Frea','Frith','Gar','Geat','Gisel','Glaed','God','Gold','Graeg','Grim',
						'Gunn','Guth','Halig','Hard','Hari','Heah','Heana','Heard','Heathu','Helm','Heort','Here','Herle',
						'Hild','Hlot','Hoga','Holen','Hrof','Hroth','Hun','Hwit','In','Isen','Kettil','Lang',
						'Leod','Leof','Mael','Maer','Maht','Mild','Mund','North','Noth','Oe','Ondes','Ord',
						'Orme','Os','Raegen','Rand','Read','Ric','Rim','Ruh','Run','Sa','Sae','Secg','Sele',
						'Sig','Sige','Snel','Stan','Strang','Sunu','Swet','Swith','Theod','Thur','Tila','Tort',
						'Treuwe','Trum','Tun','Wacer','Waer','Wald','Walt','Weald','Weard','Wict','Wig','Wil',
						'Wine','Wulf','Wusc']
						
var namesAS2F2:Array = ['aeldra','aesc','arm','beald','beorht','beorn','bert','bote',
						'brand','burg','cromb','cyne','deal','deor','dreda','ecg','eofer','flaed',
						'frea','frith','fugol','gar','geat','gifu','gild','glaed','god','gold','grim',
						'gyr','gyth','haele','hard','heah','heard','helm','here','hild','hun','in',
						'kettil','lac','leod','leofu','mael','maer','maht','mon','noth','nyd','or',
						'raed','rand','ric','rim','run','sele','sig','sige','snel','son','stan','sterre',
						'strang','sunu','swith','thorne','thryth','uald','wacer','wald','walh','waru',
						'walt','weald','weard','weorth','wict','wig','wil','wini','wise','wold',
						'wulf','wyn','wythe',]
						
var namesCM:Array = ['Alan','Alun','Arthur','Arthyen','Austell','Benesek','Blyth','Branek','Branwalather',
						'Brengy','Breoc','Bryok','Budic','Buthek','Cadan','Cador','Cadreth','Caradoc','Carasek','Carrow','Caswyn',
						'Cleder','Clemow','Clesek','Colan','Colyn','Corentyn','Cornelly','Costentyn','Costetyn','Crantok',
						'Credan','Daveth','Davy','Denzel','Digory','Docco','Doniert','Donyerth','Durngarth','Elid',
						'Enoder','Ervan','Feoc','Gawen','Gerens','Gerent','Germoc','Germoe','Glewas','Goran','Gorlas',
						'Goron','Gorthelyk','Gourgy','Gwinear','Gwynek','Herygh','Hicca','Howel','Hydroc','Iahan',
						'Ives','Jacca','Jago','Jamma','Jory','Jowan','Kaveran','Kenal','Kenan','Kenver','Kenwyn',
						'Keresyk','Kevern','Kitto','Ludwan','Maban','Madern','Malgen','Manuel','Margh','Marrek',
						'Massen','Mawgan','Maylwen','Mellyan','Melor','Melyn','Meriasek','Merryn','Milyan','Myghal',
						'Nadelek','Nechtan','Nerth','Neythen','Nicca','Padern','Pasco','Pawly','Peder','Pencast',
						'Peran','Perran','Petroc','Petrok','Piran','Rewan','Ruan','Rumon','Ryel','Samson',
						'Seleven','Selyf','Sennen','Silyen','Sithny','Sythyn','Talan','Talek','Tomas','Trevedic',
						'Tristan','Trystan','Udy','Uther','Uthno','Vark','Vyvyan','Welet','Wella','Weryn',
						'Wethinoc','Withell','Worrec','Yestin','Ythel']
						
var namesCF:Array = ['Ailla','Angelet','Arranz','Athwenna','Banallan','Barenwyn','Berlewen','Bersaba',
						'Beryan','Blejan','Bryluen','Burien','Caja','Carenza','Ceinwen','Chesten','Columba','Conwenna',
						'Cordelia','Crewenna','Cryda','Delen','Demelza','Derowen','Derwa','Dywana','Ebrel','Elestren',
						'Elowen','Endelienta','Endelyon','Eseld','Eselt','Esyld','Eva','Ewa','Ewe','Glanna','Gweniver',
						'Gwennol','Hedra','Jenifer','Jenifry','Jenna','Jowanet','Kayna','Kelynen','Kensa','Kerensa',
						'Kerenza','Keresyk','Kerra','Kew','Ladoca','Loveday','Lowenek','Lowenna','Mabyn','Manacca','Mariot',
						'Marya','Melior','Meliora','Mellear','Melloney','Mellyn','Melwyn','Melyar','Melyonen','Melyor','Meraud',
						'Merouda','Metheven','Morenwyn','Morgelyn','Morveren','Morvoren','Morwen','Morwenna','Morwennol','Morwetha',
						'Neraud','Nessa','Newlyn','Newlyna','Nonna','Rosen','Rozen','Rozenwyn','Senara','Sevi','Sowena',
						'Steren','Talwyn','Tamara','Tamsyn','Tecca','Tegen','Tregereth','Tressa','Trevenna','Tryfena',
						'Vorva','Weneppa','Wenn','Wenna','Wylmet','Ygerna','Zethar']
						
var namesCFamily:Array = ['Andrewartha','Angrave','Annear','Anning','Bain','Baragwanath','Beckerleg','Bedell','Bennetto',
							'Bennetts','Berriman','Berryman','Bescoby','Bice','Biddick','Binney','Blamey','Boase','Boden','Bolitho','Bonython',
							'Borlase','Bosanko','Bosanquet','Bray','Briddon','Bryant','Carbines','Cardell','Care','Carlyon','Carnell',
							'Carveth','Causley','Chegwidden','Chenhalls','Chenoweth','Clemow','Clemson','Climo','Clymo','Coad','Cocking',
							'Colenso','Colley','Congdon','Corin','Couch','Cowling','Craddick','Crago','Craze','Crowle','Cundy','Curnow',
							'Daniel','Deveril','Dobell','Dowling','Eade','Edwards','Ellis','Endean','Eva','Faull','Frayne','Freeman',
							'Freethy','Galtey','Geach','Geake','Godden','Gole','Goss','Gribbin','Gynn','Hain','Haines','Hambly','Hannaford',
							'Hannah','Harris','Hayne','Hendra','Hobby','Hocking','Hodge','Hollow','Hosking','Hoskins','Inch','Isbell',
							'Ivey','James','Jasper','Jelbart','Jennings','Jewell','Johns','Joliffe','Jolly','Keast','Keen','Keigwin',
							'Kempthorne','Kersey','Kestle','Kinver','Kittow','Lander','Landreth','Lanyon','Lawry','Lean','Leggo',
							'Liddicoat','Lowry','Maddaford','Maddern','Magor','Martin','Mayne','Menadue','Mitchell','Moon','Morcom',
							'Murrish','Nancarrow','Nankervis','Nankivel','Newth','Nicholls','Ninnis','Noall','Noon','Oates','Odgers','Old','Olver',
							'Opie','Otes','Palk','Pascoe','Pawley','Paynter','Pearce','Pellew','Penberthy','Pender','Pengelly','Penhaligon','Penhallow',
							'Penn','Penrose','Pentreath','Penwarden','Perkin','Perrin','Peters','Pethick','Phillips','Poldark','Polmear','Praed',
							'Prowse','Quick','Quintrell','Raddall','Restorick','Retallack','Richards','Rodda','Rogers','Rose','Roseveare','Rosewall',
							'Rosewarne','Roskelly','Roskilly','Rouncefield','Rowe','Rowse','Rule','Rundle','Ryall','Sanders','Scobel','Skewes',
							'Smith','Snell','Spargo','Stevens','Tamblyn','Tangye','Tanner','Teague','Terrill','Thomas','Tinney',
							'Tonkin','Trebilcock','Tredinnick','Trefusis','Tregear','Tregellas','Tregelles','Tregenza','Tregloan','Treglown','Tregoning',
							'Tregonning','Trelawney','Treleavin','Treloar','Tremain','Tremayne','Trembath','Tremelling','Trenance','Trerice',
							'Treseder','Tresillian','Trestrail','Trethew','Trethewey','Trethowan','Trevain','Trevaskis','Trevellick','Trevelyan',
							'Treverton','Trevethan','Trevithick','Trevorrow','Trewarthen','Treweeke','Trewhella','Trewin','Trezona',
							'Trounson','Trudgen','Truscott','Tyack','Uren','Veal','Vear','Vellenoweth','Venton','Verran','Vial',
							'Vosper','Voss','Warne','Warren','Wearne','White','Wickett','Williams','Windle','Withiel',
							'Yelland','Yourand']

var namesMEM:Array = ['Abel','Abraham','Absalon','Adam','Ailward','Alan','Alban',
						'Albin','Alexander','Alfred','Alger','Almaric','Alured','Andrew','Arnold',
						'Arthur','Aubrey','Augustine','Aymon','Aytrop','Baldwin','Bardulf','Bartelot',
						'Bartholomew','Basil','Benedict','Bernard','Brice','Christopher','Clement','David',
						'Drogo','Edmund','Edward','Elias','Ernald','Ernulf','Eustace','Everard','Fulk',
						'Fulke','Geoffrey','Gerard','Gervase','Gilbert','Giles','Gillemin','Godfrey','Godwin',
						'Graland','Gregory','Guichard','Guy','Hamo','Hamon','Harry','Harvey','Hasculf','Henry',
						'Herbert','Hereward','Howard','Huberd','Hubert','Hugh','Hugo','Humfrey','Humphrey',
						'Imbert','Ivo','Jacob','James','Jocelyn','John','Jordan','Lambert','Laurence','Luke',
						'Maneser','Martin','Matthew','Maurice','Michael','Miles','Milo','Nicholas','Nigel',
						'Norman','Odo','Oliver','Osbert','Oswald','Pagan','Paul','Peter','Philip','Piers',
						'Ralph','Randolph','Ranulf','Rauf','Rayner','Reginald','Renaud','Reynald','Richard',
						'Robert','Robin','Roger','Saer','Segod','Serlo','Sewal','Sewin','Siger','Silvester',
						'Simon','Stephen','Swain','Syward','Theobald','Thomas','Thurstan','Vincent','Wakelin',
						'Walerand','Walter','Warin','Warren','William','Wymer']

var namesMEF:Array = ['Ada','Aelicia','Agatha','Agnes','Albreda','Alditha','Aldreda',
						'Alice','Alina','Alisoun','Alveva','Alviva','Alyenora','Amabel','Amabella',
						'Amice','Amicia','Amy','Anne','Ascelina','Avelina','Avice','Barbara','Basilia',
						'Beatrice','Beatrix','Bertha','Cassandra','Castanea','Cecilia','Cecily','Celestria',
						'Christiana','Christina','Clarice','Clemencia','Constance','Custancia','Custelot','Dionise',
						'Dionisia','Edelina','Edith','Egidia','Ela','Eleanor','Elena','Elizabeth','Ellen',
						'Emma','Emmeline','Estrild','Estrilda','Eugenia','Eva','Felicia','Florence','Galiana',
						'Grecia','Guinevere','Gundreda','Gunnilda','Gunnora','Hawisia','Helewisa','Ida',
						'Idonea','Imayna','Isabel','Isabella','Iseult','Ismenia','Isold','Isotte',
						'Ivetta','Joan','Jocosa','Joia','Joyce','Juliana','Katherine','Lauretta','Lecelina',
						'Lecia','Leticia','Lettice','Loveday','Lucia','Lucy','Mabel','Mabillia','Magdalen',
						'Margaret','Margery','Marsilla','Mary','Matilda','Maud','May','Meliora','Melisant','Muriel',
						'Nicola','Petronella','Philippa','Ragenild','Roesia','Rohesia','Rosamund','Rose','Sabine',
						'Saeva','Sara','Sayna','Sibyl','Susanna','Theophania','Willelma']

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(1): getName()
	
func getName() -> String:
	var results:String = ''
	
	var myCategory:String = optsCategory.pick_random()
	var myGender:String = optsGender.pick_random()
	var myElements:int = optsElements.pick_random()

	results = GenerateName(myCategory, myGender, myElements)
	if DEBUG: print(util.prefix('B'), 'Name generated (', myCategory, ' ', myGender,  ' ', str(myElements), '): ', results)
	
	return results
	
func GenerateName(category:String='', gender:String='', elements:int=0) -> String:
	var results:String = '12345678901234567890'
	
	while results.length() > 14:
		
		if category == 'Anglo-Saxon':
			if elements == 1:
				results = namesAS1.pick_random()
				
			elif elements == 2:
				var _elementsHolder:Array = []
				
				if gender == 'M':
						results = PickTwoUniqueFrom(namesAS2M1, namesAS2M2)
						
				elif gender == 'F':
					results = PickTwoUniqueFrom(namesAS2F1, namesAS2F2)
						
		elif category == 'Cornish':
			#removed multi-element Cornish names... 3-part names with a 14char limit were generating weird names too frequently
			
			#if elements == 1:
			if gender == 'M':
				results = PickTwoUniqueFrom(namesCM, namesCFamily, ' ')
			elif gender == 'F':
				results = PickTwoUniqueFrom(namesCF, namesCFamily, ' ')
#
			#elif elements == 2:
#				if gender == 'M':
#					results = PickTwoUniqueFrom(namesCM, namesCM, ' ')
#					results = results + str(' ' + namesCFamily.pick_random())
#				elif gender == 'F':
#					results = PickTwoUniqueFrom(namesCF, namesCF, ' ')
#					results = results + str(' ' + namesCFamily.pick_random())		
					
		elif category == 'Medieval English':
			if gender == 'M': results = namesMEM.pick_random()
			if gender == 'F': results = namesMEF.pick_random()
			
	return results

func PickTwoUniqueFrom(list1:Array=[], list2:Array=[], space:String='') -> String:
	var results:String = ''
	var elementsHolder:Array = []
	if list1.size() > 0 and list2.size() > 0:
		elementsHolder.append(list1.pick_random())
		elementsHolder.append(elementsHolder[0])
		
		while elementsHolder[1] == elementsHolder[0]:
			elementsHolder.remove_at(1)
			elementsHolder.append(list2.pick_random())
			results = str(elementsHolder[0] + space + elementsHolder[1])
			
	return results
