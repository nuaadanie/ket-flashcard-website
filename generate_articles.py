#!/usr/bin/env python3
"""Generate reading articles JSON for KET flashcard app."""
import json

# Hand-crafted articles covering KET vocabulary by level
articles = []
aid = 0

# ============ 黑1 Articles (简单句, 80-120词) ============

def a(title, level, topics, paragraphs):
    global aid
    aid += 1
    return {
        "id": aid,
        "title": title,
        "level": level,
        "topics": topics,
        "paragraphs": [{"en": p[0], "zh": p[1], "keywords": p[2]} for p in paragraphs]
    }

# 黑1-1: Animals
articles.append(a(
    "My Favourite Animals",
    "黑1",
    ["Animals（动物）"],
    [
        ("I love animals. My favourite animal is a cat.", "我喜欢动物。我最喜欢的动物是猫。", ["animal", "cat"]),
        ("My cat is small and grey. She has big green eyes.", "我的猫又小又灰。她有一双大大的绿色眼睛。", ["cat", "grey", "green", "eye"]),
        ("My friend has a dog. The dog is brown and very happy.", "我的朋友有一只狗。这只狗是棕色的，非常开心。", ["friend", "dog", "brown"]),
        ("At the zoo, I can see a bear, a crocodile and a monkey.", "在动物园里，我能看到一只熊、一条鳄鱼和一只猴子。", ["bear", "crocodile", "monkey"]),
        ("The elephant is very big. The mouse is very small.", "大象非常大。老鼠非常小。", ["elephant", "mouse"]),
        ("Birds can fly in the sky. Fish can swim in the water.", "鸟能在天空中飞。鱼能在水里游。", ["bird", "fish"]),
        ("On the farm, there are chickens, cows and horses.", "在农场上，有鸡、牛和马。", ["chicken", "cow", "horse"]),
        ("I want a pet. Maybe a rabbit or a turtle!", "我想要一只宠物。也许是一只兔子或一只乌龟！", ["pet", "rabbit"]),
    ]
))

# 黑1-2: Family & Friends
articles.append(a(
    "My Family",
    "黑1",
    ["Family & friends（家人与朋友）"],
    [
        ("This is my family. I live with my mum and dad.", "这是我的家人。我和妈妈爸爸住在一起。", ["family", "mum", "dad"]),
        ("I have one brother and one sister. My brother is older than me.", "我有一个哥哥和一个妹妹。我哥哥比我大。", ["brother", "sister"]),
        ("My grandmother and grandfather live near our house.", "我的奶奶和爷爷住在我们家附近。", ["grandmother", "grandfather"]),
        ("My uncle and aunt come to visit us every weekend.", "我的叔叔和阿姨每个周末都来看我们。", ["uncle", "aunt"]),
        ("I have three cousins. We like to play together.", "我有三个表兄妹。我们喜欢一起玩。", ["cousin"]),
        ("My best friend is Tom. He is my classmate at school.", "我最好的朋友是汤姆。他是我的同学。", ["friend", "classmate"]),
        ("Our family is not very big, but we are very happy.", "我们家不是很大，但我们很幸福。", ["family"]),
    ]
))

# 黑1-3: Food & Drink
articles.append(a(
    "What I Eat Every Day",
    "黑1",
    ["Food & drink（食物与饮料）"],
    [
        ("For breakfast, I eat bread and drink milk.", "早餐，我吃面包喝牛奶。", ["breakfast", "bread", "milk"]),
        ("Sometimes I have an egg and some juice too.", "有时候我还吃一个鸡蛋，喝一些果汁。", ["egg", "juice"]),
        ("For lunch, I like rice with chicken or fish.", "午餐，我喜欢吃米饭配鸡肉或鱼。", ["lunch", "rice", "chicken", "fish"]),
        ("I love fruit. Apples and bananas are my favourite.", "我喜欢水果。苹果和香蕉是我最喜欢的。", ["fruit", "apple", "banana"]),
        ("For dinner, my mum makes pasta or a burger.", "晚餐，妈妈做意面或汉堡。", ["dinner", "pasta", "burger"]),
        ("I like cake and candy, but mum says not too much!", "我喜欢蛋糕和糖果，但妈妈说不能吃太多！", ["cake", "candy"]),
        ("We always drink water. Water is good for you.", "我们总是喝水。水对你有好处。", ["water"]),
        ("On my birthday, we eat pizza and ice cream!", "在我生日那天，我们吃比萨和冰淇淋！", ["pizza", "ice cream"]),
    ]
))

# 黑1-4: The Home
articles.append(a(
    "Our House",
    "黑1",
    ["The home（家与家居）", "The home (Continued)（家与家居 续）"],
    [
        ("We live in a big apartment. It has five rooms.", "我们住在一个大公寓里。它有五个房间。", ["apartment"]),
        ("My bedroom has a bed, a desk and a bookcase.", "我的卧室有一张床、一张书桌和一个书架。", ["bedroom", "bed", "desk", "bookcase"]),
        ("In the living room, there is a sofa and a television.", "客厅里有一张沙发和一台电视。", ["living room", "sofa", "television"]),
        ("The kitchen has a table and four chairs.", "厨房里有一张桌子和四把椅子。", ["kitchen", "table", "chair"]),
        ("My bathroom has a bath and a mirror.", "我的浴室有一个浴缸和一面镜子。", ["bathroom", "bath", "mirror"]),
        ("I do my homework at my desk. I use my computer.", "我在书桌前做作业。我用我的电脑。", ["desk", "computer"]),
        ("There is a clock on the wall and a lamp on the table.", "墙上有一个钟，桌上有一盏灯。", ["clock", "lamp", "wall", "table"]),
        ("I love my room. It is my favourite place in the house.", "我喜欢我的房间。它是家里我最喜欢的地方。", []),
    ]
))

# 黑1-5: Clothes & Colours
articles.append(a(
    "Getting Dressed",
    "黑1",
    ["Clothes（衣物）", "Colours（颜色）"],
    [
        ("Today I need to get dressed for school.", "今天我需要穿好衣服去上学。", ["clothes"]),
        ("I put on my white shirt and blue trousers.", "我穿上白色衬衫和蓝色裤子。", ["shirt", "blue", "trousers"]),
        ("Then I put on my shoes and my jacket.", "然后我穿上鞋子和夹克。", ["shoes", "jacket"]),
        ("My hat is red and my bag is black.", "我的帽子是红色的，书包是黑色的。", ["hat", "red", "bag", "black"]),
        ("My sister wears a pink dress and white boots.", "我妹妹穿着粉色连衣裙和白色靴子。", ["sister", "dress", "boots", "pink", "white"]),
        ("In winter, I wear a warm coat and a scarf.", "冬天，我穿暖和的外套，戴围巾。", []),
        ("My favourite colour is green. What is yours?", "我最喜欢的颜色是绿色。你的呢？", ["colour", "green"]),
    ]
))

# 黑1-6: Body & Face
articles.append(a(
    "My Body",
    "黑1",
    ["The body & the face（身体与面部）"],
    [
        ("I have two eyes, one nose and one mouth.", "我有两只眼睛、一个鼻子和一张嘴。", ["eye", "nose", "mouth"]),
        ("My hair is black and short.", "我的头发又黑又短。", ["hair", "black"]),
        ("I have two ears. I can hear music with my ears.", "我有两只耳朵。我能用耳朵听音乐。", ["ear"]),
        ("I use my hands to write and my legs to run.", "我用手写字，用腿跑步。", ["hand", "leg"]),
        ("My feet are small. I need new shoes!", "我的脚很小。我需要新鞋子！", ["foot/feet", "shoes"]),
        ("I have two arms. I can carry my bag with my arms.", "我有两只胳膊。我能用胳膊提书包。", ["arm", "bag"]),
        ("My face is round. I have a big smile.", "我的脸是圆的。我有一个大大的微笑。", ["face"]),
    ]
))

# 黑1-7: Places
articles.append(a(
    "Around My Town",
    "黑1",
    ["Places & directions（地点与方向）"],
    [
        ("I live in a small town. There are many places to go.", "我住在一个小镇上。有很多地方可以去。", []),
        ("The bookshop is next to the park.", "书店在公园旁边。", ["bookshop", "next to", "park"]),
        ("The school is between the library and the hospital.", "学校在图书馆和医院之间。", ["between", "school"]),
        ("Go straight and turn left. The shop is at the end of the street.", "直走然后左转。商店在街道尽头。", ["left", "end", "street"]),
        ("My house is behind the supermarket.", "我家在超市后面。", ["behind"]),
        ("The playground is in front of the school.", "操场在学校前面。", ["in front of"]),
        ("I walk to school every day. It is not far from here.", "我每天走路去上学。离这里不远。", ["here"]),
    ]
))

# ============ 蓝2 Articles (复合句, 120-180词) ============

# 蓝2-1: Animals & Nature
articles.append(a(
    "A Trip to the Wildlife Park",
    "蓝2",
    ["Animals（动物）"],
    [
        ("Last weekend, my family went to the wildlife park.", "上周末，我的家人去了野生动物园。", []),
        ("We saw dolphins jumping out of the water. They were amazing!", "我们看到海豚从水中跳出来。它们太棒了！", ["dolphin"]),
        ("There was a lion sleeping under a big tree.", "有一只狮子在一棵大树下睡觉。", ["lion"]),
        ("The kangaroo was jumping very fast with her baby.", "袋鼠带着她的宝宝跳得很快。", ["kangaroo"]),
        ("We walked through the jungle area and saw a parrot.", "我们穿过丛林区域，看到了一只鹦鹉。", ["jungle", "parrot"]),
        ("My little sister was afraid of the snake, but I thought it was cool.", "我妹妹害怕蛇，但我觉得它很酷。", ["afraid", "snake"]),
        ("The bat only comes out at night. We saw it in a dark room.", "蝙蝠只在晚上出来。我们在一个黑暗的房间里看到了它。", ["bat"]),
        ("I want to go back again because there are more animals to see.", "我想再去一次，因为还有更多动物可以看。", ["because"]),
    ]
))

# 蓝2-2: Health
articles.append(a(
    "A Visit to the Doctor",
    "蓝2",
    ["Health（健康）"],
    [
        ("Yesterday I did not feel well. I had a bad cold and a cough.", "昨天我感觉不舒服。我得了重感冒，还咳嗽。", ["cold", "cough"]),
        ("My mum took me to see the doctor.", "妈妈带我去看医生。", ["doctor"]),
        ("The doctor looked at my throat and checked my temperature.", "医生看了我的喉咙，量了体温。", ["doctor", "temperature"]),
        ("She said I should stay in bed and drink lots of water.", "她说我应该卧床休息，多喝水。", []),
        ("She gave me some medicine to take three times a day.", "她给了我一些药，一天吃三次。", ["medicine"]),
        ("I also had a toothache, so I need to visit the dentist next week.", "我还牙疼，所以下周需要去看牙医。", ["toothache", "dentist"]),
        ("My friend fell down and hurt his arm. He had to go to hospital.", "我的朋友摔倒了，伤了胳膊。他不得不去医院。", ["fall", "hurt", "hospital"]),
        ("Now I feel much better. I can go back to school tomorrow.", "现在我感觉好多了。明天可以回学校了。", ["better"]),
    ]
))

# 蓝2-3: Places & Directions
articles.append(a(
    "Finding My Way",
    "蓝2",
    ["Places & directions（地点与方向）"],
    [
        ("I am new in this city and I need to find the bus station.", "我刚到这个城市，需要找到公交车站。", ["bus station"]),
        ("I asked a woman for directions. She was very helpful.", "我向一位女士问路。她非常热心。", []),
        ("She said: Go along this road, past the car park.", "她说：沿着这条路走，经过停车场。", ["along", "car park"]),
        ("Turn right at the corner. The bus stop is opposite the library.", "在拐角处右转。公交站在图书馆对面。", ["corner", "opposite"]),
        ("The centre of the city has many tall buildings.", "市中心有很多高楼。", ["centre", "building"]),
        ("Above the shop, there is a flat. Below the flat, there is a restaurant.", "商店上面有一间公寓。公寓下面有一家餐厅。", ["above", "below"]),
        ("I finally found the bus station. It was near the train station.", "我终于找到了公交车站。它在火车站附近。", ["bus station", "near"]),
        ("Next time, I will use a map on my phone!", "下次，我会用手机上的地图！", []),
    ]
))

# 蓝2-4: Food & Drink
articles.append(a(
    "Cooking with Grandma",
    "蓝2",
    ["Food & drink（食物与饮料）"],
    [
        ("Every Saturday, I cook with my grandma.", "每个星期六，我和奶奶一起做饭。", []),
        ("Today we are making a cake. We need a bowl, some flour and sugar.", "今天我们做蛋糕。我们需要一个碗、一些面粉和糖。", ["bowl"]),
        ("First, we put butter and sugar in the bowl and mix them.", "首先，我们把黄油和糖放进碗里搅拌。", ["bowl"]),
        ("Then we add the eggs and some milk.", "然后我们加入鸡蛋和一些牛奶。", []),
        ("Grandma makes the best coffee. She drinks it from a big cup.", "奶奶泡的咖啡最好喝。她用一个大杯子喝。", ["coffee", "cup"]),
        ("I am hungry, so I eat some cheese and bread while we wait.", "我饿了，所以在等待的时候吃了一些奶酪和面包。", ["hungry", "cheese"]),
        ("The cake is ready! It looks beautiful. We put it on a plate.", "蛋糕做好了！看起来很漂亮。我们把它放在盘子里。", ["plate"]),
        ("I love cooking because you can make something delicious.", "我喜欢做饭，因为你可以做出美味的东西。", ["because"]),
    ]
))

# 蓝2-5: Home & Living
articles.append(a(
    "My New Home",
    "蓝2",
    ["The home（家与家居）", "The home (Continued)（家与家居 续）"],
    [
        ("We moved to a new house last month. It has a balcony!", "我们上个月搬到了新房子。它有一个阳台！", ["balcony"]),
        ("The house has two floors. Downstairs there is a big kitchen.", "房子有两层。楼下有一个大厨房。", ["downstairs", "floor"]),
        ("We take the lift to go upstairs. My bedroom is on the second floor.", "我们坐电梯上楼。我的卧室在二楼。", ["lift", "floor"]),
        ("I can see the roof of the next building from my window.", "从我的窗户可以看到隔壁楼的屋顶。", ["roof", "building"]),
        ("There is a shower in the bathroom and a seat by the window.", "浴室里有一个淋浴，窗边有一个座位。", ["shower", "seat"]),
        ("My mum put a blanket on my bed. It is very warm.", "妈妈在我床上放了一条毯子。非常暖和。", ["blanket"]),
        ("I had a dream last night about our old house. I miss it a little.", "昨晚我梦到了我们的老房子。我有点想念它。", ["dream"]),
        ("But this new home is great. I sent a message to my friend about it.", "但这个新家很棒。我给朋友发了一条消息。", ["message"]),
    ]
))

# 蓝2-6: Sports & Body
articles.append(a(
    "Sports Day at School",
    "蓝2",
    ["Sports & leisure (Continued)（运动与休闲 续）", "The body & the face（身体与面部）"],
    [
        ("Today is Sports Day at school. Everyone is excited.", "今天是学校的运动会。每个人都很兴奋。", []),
        ("I always wear my helmet when I ride my bike.", "我骑自行车时总是戴头盔。", ["helmet"]),
        ("My friend Charlie has a beard now. He looks much older!", "我的朋友查理现在留了胡子。他看起来老多了！", ["beard"]),
        ("The tall boy with curly hair won the race. He ran very fast.", "那个卷发的高个子男孩赢了比赛。他跑得很快。", ["curly"]),
        ("After the race, my neck and back hurt because I ran too hard.", "赛跑后，我的脖子和背疼，因为我跑得太用力了。", ["neck", "back"]),
        ("We walked around the field and watched every game carefully.", "我们绕着操场走，仔细观看每场比赛。", ["carefully"]),
        ("The video of the race was very popular online.", "比赛的视频在网上很受欢迎。", ["video"]),
        ("It was the best day ever. I never want to forget it.", "这是最棒的一天。我永远不想忘记它。", ["best", "never"]),
    ]
))

# 蓝2-7: Clothes & Shopping
articles.append(a(
    "Shopping for Clothes",
    "蓝2",
    ["Clothes（衣物）"],
    [
        ("My mum and I went shopping for new clothes yesterday.", "昨天我和妈妈去买新衣服了。", []),
        ("I need a new coat because winter is coming.", "我需要一件新外套，因为冬天要来了。", ["coat", "because"]),
        ("We also bought a warm sweater and a swimsuit for the holiday.", "我们还买了一件暖和的毛衣和一件泳衣准备度假。", ["sweater", "swimsuit"]),
        ("My sister wanted a scarf. She chose a red one.", "我妹妹想要一条围巾。她选了一条红色的。", ["scarf"]),
        ("The shop was very busy. There were lots of people inside.", "商店很忙。里面有很多人。", ["inside"]),
        ("I tried on both the blue coat and the green one.", "我两件都试了，蓝色的和绿色的。", ["both"]),
        ("The blue one was better, so I bought it.", "蓝色的更好，所以我买了它。", ["better"]),
        ("We carried all the bags to the car park.", "我们把所有的袋子提到了停车场。", ["carry", "car park"]),
    ]
))

# 蓝2-8: IT & Modern Life
articles.append(a(
    "My Digital Life",
    "蓝2",
    ["IT（信息技术）", "Sports & leisure (Continued)（运动与休闲 续）"],
    [
        ("I use my laptop every day for homework and games.", "我每天用笔记本电脑做作业和玩游戏。", ["laptop"]),
        ("My favourite app helps me learn new words.", "我最喜欢的应用帮我学习新单词。", ["app"]),
        ("I also read e-books on my tablet before I go to sleep.", "我睡觉前也在平板上看电子书。", ["e-book"]),
        ("Last night, I watched a video about how to make a robot.", "昨晚，我看了一个关于如何制作机器人的视频。", ["video"]),
        ("My friend sent me a message about a new game.", "我的朋友给我发了一条关于新游戏的消息。", ["message"]),
        ("We play online together every weekend. It is always fun.", "我们每个周末一起在线玩。总是很有趣。", ["always"]),
        ("Sometimes I spend too much time on my phone.", "有时候我在手机上花太多时间了。", []),
        ("My mum says I should go outside more often.", "妈妈说我应该更经常出去。", ["outside", "more"]),
    ]
))

# ============ 红3 Articles (更复杂, 150-250词) ============

# 红3-1: Places & Adventure
articles.append(a(
    "An Amazing Adventure",
    "红3",
    ["Places & directions（地点与方向）", "Nouns（名词）"],
    [
        ("Last summer, my family went on an amazing adventure to a small island.", "去年夏天，我的家人去了一个小岛上进行了一次奇妙的冒险。", ["adventure"]),
        ("We took a plane to the airport, then a bus to the harbour.", "我们坐飞机到机场，然后坐公共汽车到港口。", ["airport", "harbour"]),
        ("From the harbour, we crossed a bridge to reach the island.", "从港口出发，我们过了一座桥到达了小岛。", ["bridge"]),
        ("The island had a beautiful castle on top of a hill.", "岛上有一座美丽的城堡，在山顶上。", ["castle"]),
        ("We walked along the path through the forest to the castle.", "我们沿着穿过森林的小路走到城堡。", ["path", "forest"]),
        ("Inside the castle, there was a museum with old paintings.", "城堡里面有一个博物馆，里面有古老的画作。", ["museum"]),
        ("We had lunch at a restaurant near the corner of the main square.", "我们在主广场拐角附近的一家餐厅吃了午饭。", ["restaurant", "corner"]),
        ("The whole trip was a wonderful experience. I want to go again!", "整个旅行是一次美妙的经历。我想再去一次！", ["experience"]),
    ]
))

# 红3-2: Sports & Leisure
articles.append(a(
    "The School Talent Show",
    "红3",
    ["Sports & leisure (Continued)（运动与休闲 续）"],
    [
        ("Every year, our school has a talent show. Students can sing, dance or play music.", "每年，我们学校都有才艺表演。学生们可以唱歌、跳舞或演奏音乐。", ["sing"]),
        ("My friend Alex decided to play the guitar on stage.", "我的朋友亚历克斯决定在舞台上弹吉他。", ["guitar"]),
        ("Anna wanted to sing a song, but she was very nervous.", "安娜想唱一首歌，但她非常紧张。", ["sing"]),
        ("Ben and his team did a skateboard show. The audience loved it!", "本和他的团队表演了滑板秀。观众们很喜欢！", ["skateboard"]),
        ("Grace took a beautiful picture of the whole show.", "格蕾丝拍了一张整场表演的漂亮照片。", ["picture"]),
        ("We listened to the radio interview about the show the next day.", "第二天我们听了关于表演的广播采访。", ["radio"]),
        ("Some students read poems and others told funny stories.", "一些学生朗读诗歌，其他人讲有趣的故事。", ["read"]),
        ("At the end, everyone clapped and cheered. It was fantastic!", "最后，每个人都鼓掌欢呼。太棒了！", ["clap"]),
        ("I want to ride my bike on stage next year. That would be fun!", "我明年想在舞台上骑自行车。那一定很有趣！", ["ride", "fun"]),
    ]
))

# 红3-3: Food & Kitchen
articles.append(a(
    "Cooking Competition",
    "红3",
    ["Food & drink（食物与饮料）", "The home（家与家居）"],
    [
        ("Our class had a cooking competition last Friday.", "上周五我们班举行了一场烹饪比赛。", []),
        ("Each team had to make something using flour, butter and eggs.", "每个团队必须用面粉、黄油和鸡蛋做一些东西。", ["flour", "butter"]),
        ("My team decided to make biscuits with honey and cereal on top.", "我的团队决定做饼干，上面放蜂蜜和麦片。", ["biscuit", "honey", "cereal"]),
        ("We used a fork to mix everything in a big bowl.", "我们用叉子在一个大碗里搅拌所有东西。", ["fork"]),
        ("Then we put the biscuits in the oven and waited.", "然后我们把饼干放进烤箱等待。", ["oven"]),
        ("Another team made cookies with chocolate. They smelled amazing.", "另一个团队做了巧克力曲奇。闻起来太香了。", ["cookie"]),
        ("We used chopsticks to eat some noodles while waiting.", "等待的时候我们用筷子吃了一些面条。", ["chopsticks"]),
        ("The teacher said our biscuits were the best. We won first place!", "老师说我们的饼干是最好的。我们赢得了第一名！", []),
        ("I put the recipe in my diary so I can make them again at home.", "我把食谱写在日记里，这样我可以在家再做。", ["diary", "fridge"]),
    ]
))

# 红3-4: Adjectives & Descriptions
articles.append(a(
    "A Strange Day",
    "红3",
    ["Adjectives（形容词）"],
    [
        ("It was a strange day. Everything felt different from usual.", "这是奇怪的一天。一切都和平时不一样。", ["different"]),
        ("The sky was not blue but grey and dark.", "天空不是蓝色的，而是灰色的、暗暗的。", ["grey", "dark"]),
        ("I felt tired and hungry when I woke up.", "我醒来时感觉又累又饿。", ["tired", "hungry"]),
        ("The street was empty and quiet. Nobody was outside.", "街道空荡荡的，很安静。没有人在外面。", ["empty", "quiet"]),
        ("Then I heard a loud noise. It was very scary!", "然后我听到一声巨响。非常吓人！", ["loud", "scary"]),
        ("I looked outside and saw something amazing and beautiful.", "我往外看，看到了一些令人惊叹和美丽的东西。", ["amazing", "beautiful"]),
        ("A hot air balloon was flying low over the buildings!", "一个热气球正低低地飞过建筑物上方！", []),
        ("It was colourful — red, yellow, green and purple.", "它色彩缤纷——红色、黄色、绿色和紫色。", ["colourful", "purple"]),
        ("The whole neighbourhood came outside to watch. Everyone was excited and happy.", "整个社区的人都出来观看。每个人都很兴奋和开心。", ["excited", "happy"]),
        ("It turned out to be a special event. What a wonderful surprise!", "原来这是一个特别的活动。多么美妙的惊喜！", ["special", "wonderful"]),
    ]
))

# 红3-5: Verbs & Actions
articles.append(a(
    "A Busy Weekend",
    "红3",
    ["Verbs – regular（规则动词）", "Verbs – irregular（不规则动词）"],
    [
        ("Last weekend was very busy. I did so many things!", "上个周末非常忙碌。我做了好多事情！", []),
        ("On Saturday morning, I cleaned my room and washed my clothes.", "周六早上，我打扫了房间，洗了衣服。", ["clean"]),
        ("Then I walked to the shop and bought some food.", "然后我走到商店买了一些食物。", []),
        ("In the afternoon, I chose a new book from the library and started to read it.", "下午，我从图书馆选了一本新书，开始阅读。", ["choose", "read"]),
        ("My friend came to visit. We played games and counted our card collection.", "我的朋友来拜访。我们玩游戏，数了我们的卡片收藏。", ["come", "count"]),
        ("On Sunday, I got up early and went to the park.", "周日，我早起去了公园。", ["get"]),
        ("I tried to learn how to skateboard, but I kept falling!", "我试着学滑板，但一直摔倒！", ["try"]),
        ("After that, I added some new photos to my album.", "之后，我在相册里添加了一些新照片。", ["add"]),
        ("In the evening, I completed my homework and went to bed.", "晚上，我完成了作业就上床睡觉了。", ["complete", "go to bed"]),
    ]
))

# 红3-6: Animals & Nature
articles.append(a(
    "The Nature Documentary",
    "红3",
    ["Animals（动物）", "Colours（颜色）"],
    [
        ("Last night, I watched a nature documentary on television.", "昨晚，我在电视上看了一部自然纪录片。", []),
        ("It was about creatures that live in different parts of the world.", "它讲的是生活在世界不同地方的生物。", ["creature"]),
        ("The eagle flew high above the mountains. It was looking for food.", "鹰在山上高高飞翔。它在寻找食物。", ["eagle"]),
        ("A beautiful butterfly with gold and silver wings landed on a flower.", "一只有着金色和银色翅膀的美丽蝴蝶落在一朵花上。", ["butterfly", "gold", "silver"]),
        ("The camel walked slowly across the hot desert.", "骆驼慢慢地走过炎热的沙漠。", ["camel"]),
        ("Some animals have spots and some have stripes.", "有些动物有斑点，有些有条纹。", ["spot", "stripe"]),
        ("The spotted beetle was tiny but very colourful.", "那只有斑点的甲虫很小但非常鲜艳。", ["spotted", "beetle"]),
        ("Sadly, some animals like dinosaurs are now extinct.", "遗憾的是，一些动物如恐龙现在已经灭绝了。", ["dinosaur", "extinct"]),
        ("We should protect animals and their fur, feathers and homes.", "我们应该保护动物和它们的皮毛、羽毛和家园。", ["fur"]),
    ]
))

# 红3-7: Health & Body
articles.append(a(
    "First Aid at School",
    "红3",
    ["Health（健康）", "The body & the face（身体与面部）"],
    [
        ("Today we had a first aid lesson at school.", "今天我们在学校上了一节急救课。", []),
        ("The teacher showed us how to use a bandage.", "老师教我们如何使用绷带。", ["bandage"]),
        ("If someone has a cut on their finger, you should clean it first.", "如果有人手指上有伤口，你应该先清洗。", ["cut", "finger"]),
        ("Then put a bandage on it to keep it clean.", "然后贴上绷带保持清洁。", ["bandage"]),
        ("If someone falls over and hurts their knee or elbow, help them sit down.", "如果有人摔倒伤了膝盖或肘部，帮他们坐下。", ["fall over", "knee", "elbow"]),
        ("Sometimes you need to go to the chemist to buy medicine.", "有时候你需要去药店买药。", ["chemist('s)", "medicine"]),
        ("For serious problems, you might need an x-ray at the hospital.", "对于严重的问题，你可能需要在医院拍X光。", ["x-ray"]),
        ("The teacher told us about the toe — even a small injury needs care.", "老师告诉我们关于脚趾的知识——即使是小伤也需要护理。", ["toe"]),
        ("I learned a lot today. First aid is an important skill for everyone.", "我今天学到了很多。急救是每个人的重要技能。", []),
    ]
))

# 红3-8: Home & Materials
articles.append(a(
    "Building a Treehouse",
    "红3",
    ["Materials（材料）", "The home (Continued)（家与家居 续）"],
    [
        ("My dad and I decided to build a treehouse in our garden.", "我和爸爸决定在花园里建一个树屋。", []),
        ("We needed lots of wood for the walls and the floor.", "我们需要很多木头来做墙壁和地板。", ["wood"]),
        ("Dad bought some metal nails and a plastic box for our tools.", "爸爸买了一些金属钉子和一个塑料盒子装工具。", ["metal", "plastic"]),
        ("We used paper to draw the plan first.", "我们先用纸画了设计图。", ["paper"]),
        ("The window was made of glass so we could see outside.", "窗户是玻璃做的，这样我们可以看到外面。", ["glass"]),
        ("We put a shelf on the wall for books and a key hook by the gate.", "我们在墙上装了一个架子放书，在门边装了一个钥匙挂钩。", ["shelf", "key", "gate"]),
        ("I wrote a letter to my friend and put it in an envelope.", "我给朋友写了一封信，放进了信封里。", ["letter", "envelope"]),
        ("The screen of my tablet showed a video about how to build treehouses.", "我平板电脑的屏幕上播放着一个关于如何建树屋的视频。", ["screen"]),
        ("We also added some card decorations and used shampoo bottles as flower pots!", "我们还加了一些卡纸装饰，用洗发水瓶子当花盆！", ["card", "shampoo"]),
        ("The treehouse is now my favourite place to read and dream.", "树屋现在是我最喜欢的阅读和做梦的地方。", []),
    ]
))

# 红3-9: Clothes & Fashion
articles.append(a(
    "The Costume Party",
    "红3",
    ["Clothes（衣物）"],
    [
        ("Our school is having a costume party next week.", "我们学校下周要举办一个化装舞会。", ["costume"]),
        ("I want to dress up as a king, so I need a crown.", "我想打扮成国王，所以我需要一顶王冠。", ["crown"]),
        ("My sister wants to be a princess. She has a beautiful necklace and bracelet.", "我妹妹想当公主。她有一条漂亮的项链和手镯。", ["necklace", "bracelet"]),
        ("My friend will wear striped pyjamas and pretend to be a sleepwalker!", "我的朋友会穿条纹睡衣，假装是梦游者！", ["striped", "pyjamas"]),
        ("I also need gloves and a belt to complete my costume.", "我还需要手套和腰带来完成我的装扮。", ["glove", "belt"]),
        ("The teacher said we can wear any costume we like.", "老师说我们可以穿任何我们喜欢的服装。", ["costume"]),
        ("Some students will wear spotted shirts and gold hats.", "一些学生会穿有斑点的衬衫，戴金色的帽子。", ["spotted", "gold"]),
        ("It is going to be a wonderful party. I cannot wait!", "这将是一个精彩的派对。我等不及了！", ["wonderful"]),
    ]
))

# 红3-10: Exclamations & Conversation
articles.append(a(
    "The New Student",
    "红3",
    ["Exclamations（感叹语）", "Nouns（名词）"],
    [
        ("A new student joined our class today. Her name is Eva.", "今天有一个新同学加入了我们班。她的名字叫伊娃。", ["name"]),
        ("'Hello! Hi!' I said. 'Welcome to our school.'", "'你好！嗨！'我说。'欢迎来到我们学校。'", ["hello", "Hi!"]),
        ("'Thanks! This school looks great!' she replied.", "'谢谢！这个学校看起来很棒！'她回答道。", ["Great!"]),
        ("I showed her around. 'Cool! You have a swimming pool!' she said.", "我带她参观。'酷！你们有游泳池！'她说。", ["Cool!"]),
        ("'Fantastic! And look at the art room,' I said.", "'太棒了！看看美术室，'我说。", ["Fantastic!"]),
        ("At lunch, she tried the school food. 'Brilliant!' she smiled.", "午餐时，她尝了学校的食物。'太好了！'她笑着说。", []),
        ("'Don\\'t worry about finding your way. I can help you,' I told her.", "'别担心找不到路。我可以帮你，'我告诉她。", ["don't worry"]),
        ("'Goodbye! See you tomorrow!' she said at the end of the day.", "'再见！明天见！'她在放学时说。", ["goodbye"]),
        ("Having a conversation with Eva was really fun. I think we will be good friends.", "和伊娃聊天真的很有趣。我想我们会成为好朋友。", ["conversation", "fun"]),
    ]
))

# Write output
output = {"version": "1.0", "articles": articles}
with open("flutter_app/assets/articles.json", "w", encoding="utf-8") as f:
    json.dump(output, f, ensure_ascii=False, indent=2)

print(f"Generated {len(articles)} articles")
for lv in ["黑1", "蓝2", "红3"]:
    count = len([a for a in articles if a["level"] == lv])
    print(f"  {lv}: {count} articles")
