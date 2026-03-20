#!/usr/bin/env python3
"""Generate new high-quality KET reading articles to cover all uncovered words."""
import json

# Load existing data
with open('flutter_app/assets/words.json') as f:
    words_data = json.load(f)

with open('flutter_app/assets/articles.json') as f:
    articles_data = json.load(f)

next_id = max(a['id'] for a in articles_data['articles']) + 1

new_articles = []

def add(title, level, topics, paragraphs):
    global next_id
    new_articles.append({
        "id": next_id,
        "title": title,
        "level": level,
        "topics": topics,
        "paragraphs": paragraphs
    })
    next_id += 1

# ============================================================
# 黑1 Articles
# ============================================================

add("A Day at the Zoo", "黑1", ["Animals（动物）"], [
    {"en": "Today we went to the zoo. It was a sunny day.", "zh": "今天我们去了动物园。天气晴朗。", "keywords": ["zoo"]},
    {"en": "First, we saw a tall giraffe eating leaves from a tree.", "zh": "首先，我们看到一只高高的长颈鹿在吃树上的叶子。", "keywords": ["giraffe"]},
    {"en": "The tiger had a long tail. It walked slowly in its cage.", "zh": "老虎有一条长长的尾巴。它在笼子里慢慢地走。", "keywords": ["tiger", "tail"]},
    {"en": "We saw a hippo in the water and a zebra with black and white stripes.", "zh": "我们看到一只河马在水里，还有一只有黑白条纹的斑马。", "keywords": ["hippo", "zebra"]},
    {"en": "The snake was very long. The spider was small and had eight legs.", "zh": "蛇非常长。蜘蛛很小，有八条腿。", "keywords": ["snake", "spider"]},
    {"en": "A little frog jumped into the pond. A lizard sat on a warm rock.", "zh": "一只小青蛙跳进了池塘。一只蜥蜴坐在温暖的石头上。", "keywords": ["frog", "lizard"]},
    {"en": "The duck was swimming with her babies. The donkey was eating grass.", "zh": "鸭子带着她的宝宝在游泳。驴子在吃草。", "keywords": ["duck", "donkey"]},
    {"en": "We also saw a goat, some sheep and a big polar bear.", "zh": "我们还看到了一只山羊、一些绵羊和一只大北极熊。", "keywords": ["goat", "sheep", "polar bear"]},
    {"en": "A bee flew past my head! I love the zoo.", "zh": "一只蜜蜂飞过我的头顶！我喜欢动物园。", "keywords": ["bee"]}
])

add("The Colourful Garden", "黑1", ["Colours（颜色）", "The body & the face（身体与面部）", "The home (Continued)（家与家居 续）"], [
    {"en": "My grandma has a beautiful garden behind her house.", "zh": "我奶奶的房子后面有一个美丽的花园。", "keywords": ["garden"]},
    {"en": "There are many flowers in the garden. Some are yellow and some are orange.", "zh": "花园里有很多花。有些是黄色的，有些是橙色的。", "keywords": ["flower", "yellow", "orange"]},
    {"en": "The big tree has gray branches and green leaves.", "zh": "大树有灰色的树枝和绿色的叶子。", "keywords": ["tree", "gray"]},
    {"en": "I see a purple butterfly on a flower. What a beautiful color!", "zh": "我看到一只紫色的蝴蝶在花上。多么美丽的颜色！", "keywords": ["purple", "color"]},
    {"en": "My body feels warm in the sun. I turn my head to look at the sky.", "zh": "我的身体在阳光下感觉暖暖的。我转过头看天空。", "keywords": ["body", "head"]},
    {"en": "Grandma comes out with a big smile on her face.", "zh": "奶奶带着大大的微笑走出来。", "keywords": ["smile"]},
    {"en": "She gives me an orange juice. We sit under the tree together.", "zh": "她给我一杯橙汁。我们一起坐在树下。", "keywords": []}
])

add("My Big Family", "黑1", ["Family & friends（家人与朋友）"], [
    {"en": "I live in a big house with my family. There are many people in my family.", "zh": "我和家人住在一栋大房子里。我家有很多人。", "keywords": ["live", "person/people"]},
    {"en": "My father and mother love us very much. They are our parents.", "zh": "我的爸爸和妈妈非常爱我们。他们是我们的父母。", "keywords": ["father", "mother", "parent"]},
    {"en": "I am a boy. My sister is a girl. We are children.", "zh": "我是一个男孩。我的姐姐是一个女孩。我们是孩子。", "keywords": ["boy", "girl", "child/children"]},
    {"en": "My grandma and grandpa are old but very kind.", "zh": "我的奶奶和爷爷年纪大了，但非常和蔼。", "keywords": ["grandma", "grandpa", "old"]},
    {"en": "My little sister is still a baby. She is very young.", "zh": "我的小妹妹还是个婴儿。她非常小。", "keywords": ["baby", "young"]},
    {"en": "My father is a tall man. My mother is a kind woman.", "zh": "我的爸爸是一个高个子的男人。我的妈妈是一个善良的女人。", "keywords": ["man/men", "woman/women"]},
    {"en": "I have a daughter and a son — oh wait, I mean my parents do!", "zh": "我有一个女儿和一个儿子——哦等等，我是说我的父母有！", "keywords": ["daughter", "son"]},
    {"en": "All the kids in my family like to play together. We are all grown-ups one day!", "zh": "我家所有的孩子都喜欢一起玩。我们总有一天都会长大！", "keywords": ["kids", "grown-up"]},
    {"en": "My grandparent always tells us stories before bed.", "zh": "我的祖父母总是在睡前给我们讲故事。", "keywords": ["grandparent"]},
    {"en": "My uncle has a granddaughter and a grandson. They visit us every holiday.", "zh": "我叔叔有一个外孙女和一个外孙。他们每个假期都来看我们。", "keywords": ["granddaughter", "grandson"]}
])

add("A Rainy Day at Home", "黑1", ["The home (Continued)（家与家居 续）", "The home（家与家居）"], [
    {"en": "It is raining today, so I stay at home.", "zh": "今天下雨了，所以我待在家里。", "keywords": ["home"]},
    {"en": "I open the door and look through the window. The rain is heavy.", "zh": "我打开门，透过窗户看。雨下得很大。", "keywords": ["door", "window"]},
    {"en": "I sit in the armchair in the hall and watch television.", "zh": "我坐在走廊的扶手椅上看电视。", "keywords": ["armchair", "hall", "television/TV"]},
    {"en": "My sister plays with her doll and toy cars in the dining room.", "zh": "我姐姐在餐厅里玩她的洋娃娃和玩具车。", "keywords": ["doll", "toy", "dining room"]},
    {"en": "Mum takes a picture of us with her camera. She puts the phone on the mat.", "zh": "妈妈用相机给我们拍了一张照片。她把手机放在垫子上。", "keywords": ["picture", "camera", "phone", "mat"]},
    {"en": "I find a box in the cupboard. Inside there is an old painting and a radio.", "zh": "我在橱柜里找到一个盒子。里面有一幅旧画和一台收音机。", "keywords": ["box", "cupboard", "painting", "radio"]},
    {"en": "The rug on the floor is soft. I lie on it and watch a movie.", "zh": "地板上的地毯很柔软。我躺在上面看电影。", "keywords": ["rug", "watch"]},
    {"en": "Our house is not big, but it is a nice flat. I love my home.", "zh": "我们的房子不大，但是一个不错的公寓。我爱我的家。", "keywords": ["house", "flat"]},
    {"en": "At night, I go to sleep in my warm bed.", "zh": "晚上，我在温暖的床上睡觉。", "keywords": ["sleep"]}
])

add("Going Shopping", "黑1", ["Clothes（衣物）", "Places & directions（地点与方向）"], [
    {"en": "Today I go to the shop with my mum to buy new clothes.", "zh": "今天我和妈妈去商店买新衣服。", "keywords": ["shop"]},
    {"en": "The store is near the playground. There are many things in the store.", "zh": "商店在操场附近。商店里有很多东西。", "keywords": ["store", "playground", "there"]},
    {"en": "I want to wear new jeans and a T-shirt.", "zh": "我想穿新牛仔裤和T恤。", "keywords": ["wear", "jeans", "T-shirt"]},
    {"en": "Mum puts a skirt and shorts in the basket.", "zh": "妈妈把一条裙子和一条短裤放进篮子里。", "keywords": ["skirt", "shorts"]},
    {"en": "I find a cool baseball cap on the shelf. I put it on my head.", "zh": "我在架子上找到一顶很酷的棒球帽。我把它戴在头上。", "keywords": ["baseball cap", "on"]},
    {"en": "My mum tries on some glasses and picks up a handbag.", "zh": "我妈妈试戴了一些眼镜，拿起了一个手包。", "keywords": ["glasses", "handbag"]},
    {"en": "I need new shoes and socks. My old shoe is under the chair.", "zh": "我需要新鞋子和袜子。我的旧鞋在椅子下面。", "keywords": ["shoe", "sock", "under"]},
    {"en": "I also want a new watch. I see one in the window.", "zh": "我还想要一块新手表。我在橱窗里看到了一块。", "keywords": ["watch", "in"]}
])


add("The Fruit Market", "黑1", ["Food & drink（食物与饮料）"], [
    {"en": "Every Sunday, my family goes to the market to buy food.", "zh": "每个星期天，我家人都去市场买食物。", "keywords": ["food"]},
    {"en": "I love to eat fruit. Today we buy grapes and pears.", "zh": "我喜欢吃水果。今天我们买了葡萄和梨。", "keywords": ["eat", "grape", "pear"]},
    {"en": "Mum picks up some carrots, beans and peas for dinner.", "zh": "妈妈拿了一些胡萝卜、豆子和豌豆准备晚餐。", "keywords": ["carrot", "bean", "pea"]},
    {"en": "I want a mango and a kiwi. They are sweet and delicious.", "zh": "我想要一个芒果和一个猕猴桃。它们又甜又好吃。", "keywords": ["mango", "kiwi"]},
    {"en": "Dad buys a big watermelon and a pineapple.", "zh": "爸爸买了一个大西瓜和一个菠萝。", "keywords": ["watermelon", "pineapple"]},
    {"en": "We also get some lemons and limes to make lemonade.", "zh": "我们还买了一些柠檬和青柠来做柠檬水。", "keywords": ["lemon", "lime", "lemonade"]},
    {"en": "For lunch, we have meat with potatoes and onions.", "zh": "午餐，我们吃肉配土豆和洋葱。", "keywords": ["meat", "potato", "onion"]},
    {"en": "After lunch, I drink some coconut water.", "zh": "午餐后，我喝了一些椰子水。", "keywords": ["drink", "coconut"]},
    {"en": "For a snack, I eat some chips and a tomato.", "zh": "当零食，我吃了一些薯片和一个番茄。", "keywords": ["chips", "tomato"]},
    {"en": "Mum makes meatballs and sausages for dinner. I also have some sweets and chocolate!", "zh": "妈妈做了肉丸和香肠当晚餐。我还吃了一些糖果和巧克力！", "keywords": ["meatballs", "sausage", "sweet(s)", "chocolate"]},
    {"en": "We buy some fries and a pie to take home.", "zh": "我们买了一些薯条和一个派带回家。", "keywords": ["fries", "pie"]},
    {"en": "I love oranges too. Orange is my favourite fruit.", "zh": "我也喜欢橙子。橙子是我最喜欢的水果。", "keywords": ["orange"]}
])

# ============================================================
# 蓝2 Articles
# ============================================================

add("The Brave Little Puppy", "蓝2", ["Animals（动物）"], [
    {"en": "My neighbour has a new puppy. It is very small and cute.", "zh": "我的邻居有一只新的小狗。它非常小，很可爱。", "keywords": ["puppy"]},
    {"en": "The puppy likes to chase the kitten around the garden.", "zh": "小狗喜欢在花园里追小猫。", "keywords": ["kitten"]},
    {"en": "One day, the puppy found a snail on the path. It was very slow.", "zh": "有一天，小狗在小路上发现了一只蜗牛。它非常慢。", "keywords": ["snail"]},
    {"en": "At the zoo, we saw a panda eating bamboo and a penguin standing on the ice.", "zh": "在动物园，我们看到一只熊猫在吃竹子，一只企鹅站在冰上。", "keywords": ["panda", "penguin"]},
    {"en": "The whale was huge! It could swim very fast in the water.", "zh": "鲸鱼好大！它能在水里游得很快。", "keywords": ["whale"]},
    {"en": "We saw a shark too. Everyone was a little afraid.", "zh": "我们也看到了一条鲨鱼。每个人都有点害怕。", "keywords": ["shark"]},
    {"en": "The rabbit was in a cage. I wanted to take it home.", "zh": "兔子在笼子里。我想把它带回家。", "keywords": ["rabbit", "cage"]},
    {"en": "A fly kept buzzing around my head. It was very annoying!", "zh": "一只苍蝇一直在我头边嗡嗡叫。太烦人了！", "keywords": ["fly"]}
])

add("A Picnic by the Lake", "蓝2", ["Food & drink（食物与饮料）", "Sports & leisure (Continued)（运动与休闲 续）"], [
    {"en": "Last Saturday, we went on a picnic by the lake.", "zh": "上周六，我们去湖边野餐了。", "keywords": ["picnic", "lake", "Saturday"]},
    {"en": "Mum made sandwiches and a big salad with vegetables.", "zh": "妈妈做了三明治和一份大蔬菜沙拉。", "keywords": ["sandwich", "salad", "vegetable"]},
    {"en": "We also brought a bottle of tea and some soup in a bowl.", "zh": "我们还带了一瓶茶和一碗汤。", "keywords": ["bottle", "tea", "soup"]},
    {"en": "I had pancakes with sauce. My sister drank a milkshake.", "zh": "我吃了配酱汁的煎饼。我姐姐喝了一杯奶昔。", "keywords": ["pancake", "sauce", "milkshake"]},
    {"en": "We ate noodles and pasta too. Everything was delicious.", "zh": "我们还吃了面条和意面。一切都很美味。", "keywords": ["noodles", "pasta"]},
    {"en": "After lunch, we walked around the lake. The weather was sunny.", "zh": "午餐后，我们绕着湖散步。天气晴朗。", "keywords": ["walk", "sunny", "weather"]},
    {"en": "I was thirsty, so I drank some water from a glass.", "zh": "我渴了，所以用玻璃杯喝了一些水。", "keywords": ["thirsty", "glass"]},
    {"en": "It was a wonderful weekend. I want to go again next week.", "zh": "这是一个美好的周末。我想下周再去。", "keywords": ["weekend", "week"]}
])

add("The School Trip to the Farm", "蓝2", ["Places & directions（地点与方向）", "Sports & leisure (Continued)（运动与休闲 续）"], [
    {"en": "On Tuesday, our class went on a trip to the farm.", "zh": "周二，我们班去农场旅行了。", "keywords": ["trip", "farm", "Tuesday"]},
    {"en": "We took a bus from the bus stop near the station.", "zh": "我们从车站附近的公交站坐了公共汽车。", "keywords": ["bus stop", "station"]},
    {"en": "The driver drove us along the road through the countryside.", "zh": "司机沿着公路开车带我们穿过乡村。", "keywords": ["driver", "drive", "road", "countryside"]},
    {"en": "The farmer showed us around the field. We saw many animals.", "zh": "农夫带我们参观了田野。我们看到了很多动物。", "keywords": ["farmer", "field"]},
    {"en": "We walked through the forest and saw a beautiful waterfall.", "zh": "我们穿过森林，看到了一个美丽的瀑布。", "keywords": ["forest", "waterfall"]},
    {"en": "The river was next to a small village. The ground was wet.", "zh": "河流在一个小村庄旁边。地面是湿的。", "keywords": ["river", "village", "ground"]},
    {"en": "We climbed a mountain and looked at the island in the lake.", "zh": "我们爬了一座山，看着湖中的小岛。", "keywords": ["mountain", "island"]},
    {"en": "The grass was green and the leaves were falling from the trees.", "zh": "草是绿色的，树叶从树上飘落。", "keywords": ["grass", "leaf/leaves"]},
    {"en": "We saw a rock shaped like a star. The whole world looked beautiful.", "zh": "我们看到一块像星星形状的石头。整个世界看起来很美。", "keywords": ["rock", "star", "world"]}
])

add("A Rainy Wednesday", "蓝2", ["Sports & leisure (Continued)（运动与休闲 续）"], [
    {"en": "It was Wednesday and the sky was full of clouds.", "zh": "那是星期三，天空布满了云。", "keywords": ["Wednesday", "cloud", "sky"]},
    {"en": "The weather was cloudy and windy. Then it started to rain.", "zh": "天气多云又有风。然后开始下雨了。", "keywords": ["cloudy", "windy", "rain"]},
    {"en": "I looked out the window and saw snow on the mountain.", "zh": "我望向窗外，看到山上有雪。", "keywords": ["snow"]},
    {"en": "After the rain, a beautiful rainbow appeared in the sky.", "zh": "雨后，天空中出现了一道美丽的彩虹。", "keywords": ["rainbow"]},
    {"en": "On Thursday, the wind stopped and the sun came out.", "zh": "周四，风停了，太阳出来了。", "keywords": ["Thursday", "wind"]},
    {"en": "On Friday, the ice on the lake melted. It was getting warm.", "zh": "周五，湖上的冰融化了。天气变暖了。", "keywords": ["Friday", "ice"]},
    {"en": "On Sunday, we went to the city to see a film at the cinema.", "zh": "周日，我们去城里看了一场电影。", "keywords": ["Sunday", "city", "film", "cinema"]},
    {"en": "Sometimes the weather changes every day. That is life in our town.", "zh": "有时候天气每天都在变。这就是我们小镇的生活。", "keywords": ["sometimes", "town"]}
])

add("The Treasure Hunt", "蓝2", ["Nouns（名词）", "Adjectives（形容词）"], [
    {"en": "Our teacher had a brilliant idea — a treasure hunt in the school!", "zh": "我们老师有一个绝妙的主意——在学校里寻宝！", "keywords": ["brilliant", "idea", "treasure"]},
    {"en": "The first clue was at the bottom of the stairs. It was easy to find.", "zh": "第一条线索在楼梯底部。很容易找到。", "keywords": ["bottom", "easy"]},
    {"en": "The second clue was difficult. We had to look for a round shape on the wall.", "zh": "第二条线索很难。我们必须在墙上找一个圆形。", "keywords": ["difficult", "round", "shape"]},
    {"en": "We heard a loud noise from the machine room. It was a bit frightening.", "zh": "我们听到机器房传来一声巨响。有点吓人。", "keywords": ["loud", "noise", "machine"]},
    {"en": "My friend had a good laugh when she found the clue inside a shoe.", "zh": "我的朋友在鞋子里找到线索时大笑起来。", "keywords": ["laugh"]},
    {"en": "There was a big difference between the first team and the last team.", "zh": "第一个队和最后一个队之间有很大的差距。", "keywords": ["difference", "first", "last"]},
    {"en": "What kind of treasure was it? A box of sweets for everyone!", "zh": "是什么样的宝藏呢？一盒给每个人的糖果！", "keywords": ["kind"]},
    {"en": "We went shopping at the shopping centre after school to celebrate.", "zh": "放学后我们去购物中心购物庆祝。", "keywords": ["shopping", "shopping centre"]}
])


add("My Sick Day", "蓝2", ["Health（健康）", "The body & the face（身体与面部）"], [
    {"en": "I woke up feeling ill. My head hurt and I had a headache.", "zh": "我醒来感觉不舒服。我头疼，有头痛。", "keywords": ["ill", "headache"]},
    {"en": "I also had a stomach-ache and an earache. I felt terrible.", "zh": "我还肚子疼和耳朵疼。我感觉糟透了。", "keywords": ["stomach-ache", "earache"]},
    {"en": "Mum asked: What is the matter? I said I felt sick and tired.", "zh": "妈妈问：怎么了？我说我感觉恶心又累。", "keywords": ["matter", "sick", "tired"]},
    {"en": "The nurse at school said I should go home and rest.", "zh": "学校的护士说我应该回家休息。", "keywords": ["nurse"]},
    {"en": "I started to cry because my shoulder and stomach hurt so much.", "zh": "我开始哭了，因为我的肩膀和胃太疼了。", "keywords": ["cry", "shoulder", "stomach"]},
    {"en": "Mum said: Are you fine? I said: Not really.", "zh": "妈妈说：你还好吗？我说：不太好。", "keywords": ["fine"]},
    {"en": "She gave me medicine and I brushed my tooth with my toothbrush.", "zh": "她给了我药，我用牙刷刷了牙。", "keywords": ["tooth/teeth", "toothbrush"]},
    {"en": "My hair looked messy. I was too thin and weak from being sick.", "zh": "我的头发看起来很乱。我因为生病变得又瘦又虚弱。", "keywords": ["thin", "weak"]},
    {"en": "The next day I felt much better. My face was not so fat and pale anymore.", "zh": "第二天我感觉好多了。我的脸不再那么胖和苍白了。", "keywords": ["fat"]},
    {"en": "I had straight hair again and my moustache — just kidding, I am only ten!", "zh": "我的头发又变直了，我的胡子——开玩笑的，我才十岁！", "keywords": ["straight", "moustache"]}
])

add("The Clever Detective", "蓝2", ["Adjectives（形容词）"], [
    {"en": "Jack was a clever boy. He loved solving puzzles.", "zh": "杰克是一个聪明的男孩。他喜欢解谜。", "keywords": ["clever"]},
    {"en": "One day, something different happened at school. The classroom was all wrong.", "zh": "有一天，学校发生了不同的事情。教室里一切都不对。", "keywords": ["different", "wrong"]},
    {"en": "The window was open and the room was wet. It was not safe.", "zh": "窗户开着，房间是湿的。不安全。", "keywords": ["wet", "safe"]},
    {"en": "Everyone was surprised and frightened. The teacher looked worried.", "zh": "每个人都很惊讶和害怕。老师看起来很担心。", "keywords": ["surprised", "frightened"]},
    {"en": "Jack was brave. He said: Do not worry, I have an idea.", "zh": "杰克很勇敢。他说：别担心，我有个主意。", "keywords": ["brave"]},
    {"en": "He was careful and quiet. He looked at every corner of the room.", "zh": "他很仔细，很安静。他看了房间的每个角落。", "keywords": ["careful", "quiet"]},
    {"en": "The answer was easy! The wind blew the window open. It was windy and cloudy outside.", "zh": "答案很简单！风把窗户吹开了。外面又刮风又多云。", "keywords": ["easy"]},
    {"en": "Everyone felt well again. Jack was famous in the school after that day.", "zh": "每个人都感觉好了。那天之后杰克在学校出名了。", "keywords": ["well", "famous"]}
])

add("The Exciting Funfair", "蓝2", ["Places & directions（地点与方向）", "Sports & leisure (Continued)（运动与休闲 续）"], [
    {"en": "Last weekend, we went to the funfair in the town centre.", "zh": "上周末，我们去了市中心的游乐场。", "keywords": ["funfair", "town/city centre"]},
    {"en": "We took a ticket at the station and rode the bus to the square.", "zh": "我们在车站买了票，坐公共汽车到了广场。", "keywords": ["ticket", "square"]},
    {"en": "The circus was exciting! A clown made everyone laugh.", "zh": "马戏团太刺激了！一个小丑让每个人都笑了。", "keywords": ["circus", "exciting", "clown"]},
    {"en": "We saw a pirate show and a pop star singing on stage.", "zh": "我们看了一场海盗表演和一个流行歌星在台上唱歌。", "keywords": ["pirate", "pop star"]},
    {"en": "I wanted to ride the tractor, but the line was too long.", "zh": "我想坐拖拉机，但队伍太长了。", "keywords": ["ride", "tractor"]},
    {"en": "We looked at the map to find the swimming pool and the sports centre.", "zh": "我们看地图找游泳池和体育中心。", "keywords": ["map", "swimming pool", "sports centre"]},
    {"en": "The library was next to the market. We went there to read a comic book.", "zh": "图书馆在市场旁边。我们去那里看漫画书。", "keywords": ["library", "market", "comic book"]},
    {"en": "It was the best day. I want to go to the funfair every year.", "zh": "这是最棒的一天。我想每年都去游乐场。", "keywords": ["every"]}
])

add("The Country Adventure", "蓝2", ["Sports & leisure (Continued)（运动与休闲 续）"], [
    {"en": "During the holiday, we went to the country for a trip.", "zh": "假期里，我们去乡下旅行了。", "keywords": ["holiday", "country"]},
    {"en": "We drove past a small village and stopped by a river.", "zh": "我们开车经过一个小村庄，在一条河边停下。", "keywords": []},
    {"en": "I saw a model of a boat in the shop. I wanted to buy it.", "zh": "我在商店里看到一个船的模型。我想买它。", "keywords": ["model"]},
    {"en": "We went fishing by the lake. The moon was bright at night.", "zh": "我们在湖边钓鱼。晚上月亮很亮。", "keywords": ["moon"]},
    {"en": "The cook at the hotel made us a wonderful dinner.", "zh": "酒店的厨师给我们做了一顿美味的晚餐。", "keywords": ["cook"]},
    {"en": "I like to work in the garden. I water the plants every morning.", "zh": "我喜欢在花园里干活。我每天早上给植物浇水。", "keywords": ["work", "plant"]},
    {"en": "The wave in the sea was big. We played on the beach all afternoon.", "zh": "海里的浪很大。我们整个下午都在沙滩上玩。", "keywords": ["wave"]},
    {"en": "The film star lives in this town. Everyone knows her.", "zh": "那个电影明星住在这个镇上。每个人都认识她。", "keywords": ["star"]}
])

add("Learning New Things", "蓝2", ["Verbs – irregular（不规则动词）", "Verbs – regular（规则动词）"], [
    {"en": "Yesterday, I got up early and got dressed for school.", "zh": "昨天，我早起穿好衣服去上学。", "keywords": ["get up", "get dressed"]},
    {"en": "I had to catch the bus. I got on at the bus stop.", "zh": "我必须赶公共汽车。我在公交站上了车。", "keywords": ["catch", "catch (a bus)", "get on"]},
    {"en": "At school, the teacher taught us how to build a model.", "zh": "在学校，老师教我们如何搭建一个模型。", "keywords": ["teach", "build"]},
    {"en": "I had to think carefully. I brought my tools from home.", "zh": "我必须仔细思考。我从家里带了工具。", "keywords": ["think", "bring"]},
    {"en": "My friend helped me fix the broken part. We climbed up to get more wood.", "zh": "我的朋友帮我修好了坏掉的部分。我们爬上去拿更多的木头。", "keywords": ["help", "fix", "climb"]},
    {"en": "I sent a message to invite my friends to see it.", "zh": "我发了一条消息邀请朋友们来看。", "keywords": ["send", "invite"]},
    {"en": "We had to wait for everyone. Then I took off my jacket and put on my apron.", "zh": "我们必须等所有人。然后我脱下夹克，穿上围裙。", "keywords": ["wait", "take off", "put on"]},
    {"en": "I need to practise more. I want to travel and shop around the world.", "zh": "我需要多练习。我想环游世界去购物。", "keywords": ["need", "practise", "travel", "shop"]},
    {"en": "When I grow up, I want to buy a big house and feed many animals.", "zh": "当我长大后，我想买一栋大房子，养很多动物。", "keywords": ["grow", "buy", "feed"]},
    {"en": "I must not lose my homework. I will hide it in my bag.", "zh": "我不能丢了作业。我会把它藏在书包里。", "keywords": ["lose", "hide"]}
])

add("The Morning Routine", "蓝2", ["Verbs – irregular（不规则动词）", "Verbs – regular（规则动词）", "The home (Continued)（家与家居 续）"], [
    {"en": "Every morning, I wake up at seven o'clock.", "zh": "每天早上，我七点钟醒来。", "keywords": ["wake", "o'clock"]},
    {"en": "I get undressed and take a shower. Then I wash my face.", "zh": "我脱掉衣服去洗澡。然后洗脸。", "keywords": ["get undressed", "wash"]},
    {"en": "I use my toothbrush and toothpaste to brush my teeth.", "zh": "我用牙刷和牙膏刷牙。", "keywords": ["toothpaste"]},
    {"en": "I dry my hair with a towel and walk down the stairs.", "zh": "我用毛巾擦干头发，走下楼梯。", "keywords": ["dry", "towel", "stair(s)"]},
    {"en": "I go upstairs to get my bag, then come back down.", "zh": "我上楼去拿书包，然后再下来。", "keywords": ["upstairs"]},
    {"en": "Mum calls me: Come on! You must not be late!", "zh": "妈妈叫我：快点！你不能迟到！", "keywords": ["call", "Come on!"]},
    {"en": "I look for my shoes and change into my school uniform.", "zh": "我找鞋子，换上校服。", "keywords": ["look for", "change"]},
    {"en": "I check the internet on my phone for the weather.", "zh": "我在手机上查看天气。", "keywords": ["internet"]},
    {"en": "I shout goodbye and move quickly to the bus stop.", "zh": "我大喊再见，快速走向公交站。", "keywords": ["shout", "move"]},
    {"en": "I drop my water bottle but I pick it up quickly.", "zh": "我掉了水瓶，但很快捡了起来。", "keywords": ["drop"]}
])

add("The Adjective Game", "蓝2", ["Adjectives（形容词）"], [
    {"en": "Our teacher played a game with us. She said a word and we had to act it out.", "zh": "我们老师和我们玩了一个游戏。她说一个词，我们必须表演出来。", "keywords": []},
    {"en": "Tom pretended to be asleep. Then he jumped up and said he was awake!", "zh": "汤姆假装睡着了。然后他跳起来说他醒了！", "keywords": ["asleep", "awake"]},
    {"en": "The game was not boring at all. It was very exciting.", "zh": "这个游戏一点也不无聊。非常刺激。", "keywords": ["boring"]},
    {"en": "Sally was naughty. She made a loud noise and scared everyone.", "zh": "萨莉很淘气。她发出很大的声音，吓到了每个人。", "keywords": ["naughty"]},
    {"en": "The tall boy was strong but slow. The little girl was quick and pretty.", "zh": "那个高个子男孩很强壮但很慢。那个小女孩又快又漂亮。", "keywords": ["tall", "strong", "slow", "little", "quick", "pretty"]},
    {"en": "It was hot and sunny outside, but inside it was cool and dry.", "zh": "外面又热又晴，但里面又凉爽又干燥。", "keywords": ["hot", "dry"]},
    {"en": "The huge dog was dangerous, but the sweet cat was safe.", "zh": "那只巨大的狗很危险，但那只可爱的猫很安全。", "keywords": ["huge", "dangerous", "sweet"]},
    {"en": "The worst part was when it was over. The best part was playing again!", "zh": "最糟糕的部分是游戏结束的时候。最好的部分是再玩一次！", "keywords": ["worst"]},
    {"en": "It was all right in the end. Everyone was busy but happy.", "zh": "最后一切都还好。每个人都很忙但很开心。", "keywords": ["all right", "busy"]}
])


add("The Email from My Pen Pal", "蓝2", ["Adverbs（副词）", "Adverbs (Continued)（副词 续）", "Pronouns（代词）", "Question words（疑问词）"], [
    {"en": "I got an email from my pen pal. She asked: How are you?", "zh": "我收到了笔友的一封电子邮件。她问：你好吗？", "keywords": ["how", "email"]},
    {"en": "She wanted to know how much the trip cost and how often I travel.", "zh": "她想知道旅行花了多少钱，我多久旅行一次。", "keywords": ["how much", "how often"]},
    {"en": "I wrote back: I sometimes go on holiday. When do you travel?", "zh": "我回信说：我有时候去度假。你什么时候旅行？", "keywords": ["when"]},
    {"en": "She said: I only go out on weekends. Why? Because I am busy.", "zh": "她说：我只在周末出去。为什么？因为我很忙。", "keywords": ["only", "out", "why"]},
    {"en": "Everyone likes her. Everything she does is interesting.", "zh": "每个人都喜欢她。她做的每件事都很有趣。", "keywords": ["everyone", "everything"]},
    {"en": "Someone told me she is very clever. Something about her is special.", "zh": "有人告诉我她很聪明。她有些地方很特别。", "keywords": ["someone", "something"]},
    {"en": "I asked: Which city do you live in? Where is your school?", "zh": "我问：你住在哪个城市？你的学校在哪里？", "keywords": ["which", "where"]},
    {"en": "She said: Nothing is more fun than writing to you!", "zh": "她说：没有什么比给你写信更有趣了！", "keywords": ["nothing"]},
    {"en": "I replied quickly and quietly at my desk. Then I went upstairs.", "zh": "我在书桌前快速安静地回了信。然后我上楼了。", "keywords": ["quickly", "quietly"]},
    {"en": "I slowly read her letter again. Who is this amazing person?", "zh": "我慢慢地又读了一遍她的信。这个了不起的人是谁？", "keywords": ["slowly", "who"]}
])

add("The Worse Day Ever", "蓝2", ["Adjectives（形容词）", "Adverbs (Continued)（副词 续）"], [
    {"en": "Yesterday was a bad day. Actually, it was worse than bad.", "zh": "昨天是糟糕的一天。实际上，比糟糕还糟糕。", "keywords": ["bad", "worse", "yesterday"]},
    {"en": "I woke up late. It was already half past eight.", "zh": "我起晚了。已经八点半了。", "keywords": []},
    {"en": "I ran down the stairs loudly. Mum said: Be quiet!", "zh": "我大声地跑下楼梯。妈妈说：安静点！", "keywords": ["loudly"]},
    {"en": "I went to the top of the bus but there was no seat. I had to stand at the bottom.", "zh": "我去了公共汽车的上层，但没有座位。我只好站在下层。", "keywords": ["top"]},
    {"en": "At school, I got the second question wrong. Then the third one too.", "zh": "在学校，我第二题答错了。然后第三题也错了。", "keywords": ["second", "third"]},
    {"en": "I felt badly about it. I often make mistakes when I am tired.", "zh": "我为此感觉很糟糕。我累的时候经常犯错。", "keywords": ["badly", "often"]},
    {"en": "Then it rained and I got all wet. Everything went wrong.", "zh": "然后下雨了，我全身都湿了。一切都出了问题。", "keywords": ["all"]},
    {"en": "But then my friend said: Come on! Let us play! And I felt better.", "zh": "但后来我朋友说：来吧！我们去玩！然后我感觉好多了。", "keywords": []}
])

add("The New Home", "蓝2", ["The home（家与家居）", "The home (Continued)（家与家居 续）", "Prepositions（介词）"], [
    {"en": "We moved to a new house. The address is 25 Park Road.", "zh": "我们搬到了新房子。地址是公园路25号。", "keywords": ["address"]},
    {"en": "The house has a basement. It is dark and cold down there.", "zh": "房子有一个地下室。那里又暗又冷。", "keywords": ["basement", "down"]},
    {"en": "We took the elevator to the second floor.", "zh": "我们坐电梯到了二楼。", "keywords": ["elevator"]},
    {"en": "I put my books on the shelf and my toys into the box.", "zh": "我把书放在架子上，把玩具放进盒子里。", "keywords": ["into"]},
    {"en": "The cat jumped off the table and ran around the room.", "zh": "猫从桌子上跳下来，在房间里跑来跑去。", "keywords": ["off", "around"]},
    {"en": "I looked out of the window. The garden was beautiful.", "zh": "我从窗户往外看。花园很漂亮。", "keywords": ["out of"]},
    {"en": "Mum walked up the stairs. Dad was waiting at the top.", "zh": "妈妈走上楼梯。爸爸在上面等着。", "keywords": ["up", "at"]},
    {"en": "We sat by the fire. It was warm and nice.", "zh": "我们坐在火炉旁。又暖和又舒服。", "keywords": ["by"]},
    {"en": "After dinner, I went round the house to check every room.", "zh": "晚饭后，我在房子里转了一圈检查每个房间。", "keywords": ["round", "after", "before"]}
])

add("The School Play", "蓝2", ["Sports & leisure (Continued)（运动与休闲 续）", "Places & directions（地点与方向）"], [
    {"en": "Our school is having a play on Friday. I am very excited.", "zh": "我们学校周五要演一出戏。我非常兴奋。", "keywords": []},
    {"en": "We practise every day after school. The practice is in the gym.", "zh": "我们每天放学后练习。练习在体育馆里。", "keywords": ["practice"]},
    {"en": "I play a player in a football game. My friend plays the goal keeper.", "zh": "我演一个足球比赛中的球员。我的朋友演守门员。", "keywords": ["player", "goal"]},
    {"en": "We need ice skates for one scene. The ice skating part is funny.", "zh": "有一幕我们需要溜冰鞋。溜冰的部分很搞笑。", "keywords": ["ice skates", "ice skating"]},
    {"en": "Some kids do roller skating on stage. Others skip and hop around.", "zh": "一些孩子在台上轮滑。其他人跳来跳去。", "keywords": ["roller skates", "roller skating", "skip", "hop"]},
    {"en": "We kick a ball and score a goal. The net catches the ball.", "zh": "我们踢球进了一个球。网接住了球。", "keywords": ["kick", "score", "net"]},
    {"en": "After the play, we sail paper boats in the pool. It is fun.", "zh": "演出结束后，我们在水池里放纸船。很有趣。", "keywords": ["sail", "pool"]},
    {"en": "We go shopping for a DVD of the play. We also buy a CD of the music.", "zh": "我们去买了一张演出的DVD。我们还买了一张音乐CD。", "keywords": ["go shopping", "DVD", "CD"]},
    {"en": "The movie version will come out next month. I cannot wait to see it.", "zh": "电影版下个月就要出来了。我等不及要看了。", "keywords": ["movie"]}
])

add("The Dance Competition", "蓝2", ["Sports & leisure (Continued)（运动与休闲 续）", "Places & directions（地点与方向）"], [
    {"en": "On Saturday, there was a dance competition at the sports centre.", "zh": "周六，体育中心有一场舞蹈比赛。", "keywords": ["dance"]},
    {"en": "We walked along the road to the place. It was a straight path.", "zh": "我们沿着路走到那个地方。是一条直路。", "keywords": ["place", "straight"]},
    {"en": "The band played music and everyone danced.", "zh": "乐队演奏音乐，每个人都跳舞。", "keywords": ["band"]},
    {"en": "I read a comic about dancing before the show.", "zh": "演出前我看了一本关于跳舞的漫画。", "keywords": ["comic"]},
    {"en": "We sent a text to our friends to come and watch.", "zh": "我们给朋友发了短信让他们来看。", "keywords": ["text"]},
    {"en": "The website had all the information about the event.", "zh": "网站上有关于活动的所有信息。", "keywords": ["website"]},
    {"en": "I made a mistake in my dance, but the teacher said it was all right.", "zh": "我在舞蹈中犯了一个错误，但老师说没关系。", "keywords": ["mistake"]},
    {"en": "We did our homework about the competition. It was fun to write about.", "zh": "我们写了关于比赛的作业。写起来很有趣。", "keywords": ["homework"]},
    {"en": "I want to swim in the swimming pool after the next competition.", "zh": "下次比赛后我想去游泳池游泳。", "keywords": ["swim"]}
])

# ============================================================
# 红3 Articles
# ============================================================

add("The Angry King", "红3", ["Adjectives（形容词）", "Nouns（名词）"], [
    {"en": "Once upon a time, there was an angry king who lived in a big castle.", "zh": "从前，有一个愤怒的国王住在一座大城堡里。", "keywords": ["angry", "king"]},
    {"en": "He was sad and unhappy because he had no friends.", "zh": "他很伤心、不开心，因为他没有朋友。", "keywords": ["sad", "unhappy"]},
    {"en": "The castle was ugly and dirty. Everything was broken.", "zh": "城堡又丑又脏。所有东西都坏了。", "keywords": ["ugly", "dirty", "broken"]},
    {"en": "One day, a kind and friendly girl came to visit.", "zh": "有一天，一个善良友好的女孩来拜访。", "keywords": ["kind", "friendly"]},
    {"en": "She said: Your problem is that you are alone. You need friends.", "zh": "她说：你的问题是你太孤独了。你需要朋友。", "keywords": ["problem", "alone"]},
    {"en": "The king felt sorry. He said: You are right. I have been unkind.", "zh": "国王感到抱歉。他说：你说得对。我一直不友善。", "keywords": ["sorry", "right", "unkind"]},
    {"en": "He opened the castle door and let the light come in.", "zh": "他打开了城堡的门，让光照进来。", "keywords": ["open", "light"]},
    {"en": "Soon the castle was lovely and tidy. The king was pleased and happy.", "zh": "很快城堡变得可爱又整洁。国王很高兴。", "keywords": ["lovely", "tidy", "pleased"]},
    {"en": "The secret to happiness is being nice to others. What a wonderful surprise!", "zh": "幸福的秘密是对别人好。多么美妙的惊喜！", "keywords": ["secret", "surprise"]}
])

add("The School Competition", "红3", ["Places & directions（地点与方向）", "Sports & leisure (Continued)（运动与休闲 续）"], [
    {"en": "Our school had a big competition last month.", "zh": "我们学校上个月举办了一场大型比赛。", "keywords": ["competition"]},
    {"en": "Students from the college and university also came.", "zh": "大学和学院的学生也来了。", "keywords": ["college", "university"]},
    {"en": "The teacher wrote the questions on the board. We had to answer them.", "zh": "老师把问题写在黑板上。我们必须回答。", "keywords": ["teacher", "board", "answer", "question"]},
    {"en": "I used a pen and pencil to write. I also needed a ruler and rubber.", "zh": "我用钢笔和铅笔写字。我还需要尺子和橡皮。", "keywords": ["pen", "pencil", "ruler", "rubber"]},
    {"en": "The English class was in the classroom on the second floor.", "zh": "英语课在二楼的教室里。", "keywords": ["English", "class", "classroom", "floor"]},
    {"en": "I had to spell every word correctly. The example was on the page.", "zh": "我必须正确拼写每个单词。例子在页面上。", "keywords": ["spell", "word", "correct", "example", "page"]},
    {"en": "I used the keyboard to type my answer on the computer.", "zh": "我用键盘在电脑上打出我的答案。", "keywords": ["keyboard", "computer"]},
    {"en": "The group project was about art and music. We drew a poster.", "zh": "小组项目是关于艺术和音乐的。我们画了一张海报。", "keywords": ["group", "project", "art", "music", "poster"]},
    {"en": "I won a prize! The teacher told me I did a great job.", "zh": "我赢了一个奖！老师告诉我我做得很好。", "keywords": ["prize", "great", "tell"]}
])


add("A Day in the Classroom", "红3", ["Places & directions（地点与方向）"], [
    {"en": "I sit at my desk every morning. The door is behind me.", "zh": "我每天早上坐在书桌前。门在我身后。", "keywords": ["desk", "door", "behind"]},
    {"en": "The teacher asks us to open our books and look at the lesson.", "zh": "老师让我们打开书本，看这节课的内容。", "keywords": ["book", "look", "lesson"]},
    {"en": "I listen carefully. The teacher draws a line on the board.", "zh": "我仔细听。老师在黑板上画了一条线。", "keywords": ["listen", "draw", "line"]},
    {"en": "She writes a sentence and asks us to read it.", "zh": "她写了一个句子，让我们读。", "keywords": ["sentence", "write", "read"]},
    {"en": "I use my eraser to fix a mistake. Then I colour the picture with crayons.", "zh": "我用橡皮擦改正了一个错误。然后我用蜡笔给图片上色。", "keywords": ["eraser", "colour", "crayons"]},
    {"en": "The bookcase is by the window. The wall has many paintings on it.", "zh": "书架在窗户旁边。墙上有很多画。", "keywords": ["bookcase", "window", "wall", "painting"]},
    {"en": "I know the answer! I stand up and tell the class.", "zh": "我知道答案！我站起来告诉全班。", "keywords": ["know", "stand"]},
    {"en": "The playground is outside. We can see it from the cupboard near the door.", "zh": "操场在外面。我们从门旁的柜子那里能看到它。", "keywords": ["playground", "cupboard"]},
    {"en": "I close my book and sit down. The lesson is over.", "zh": "我合上书坐下。这节课结束了。", "keywords": ["close", "sit"]},
    {"en": "I find my scissors in my backpack and cut out a paper star.", "zh": "我在背包里找到剪刀，剪出一颗纸星星。", "keywords": ["find", "scissors", "backpack"]}
])

add("The Sports Festival", "红3", ["Places & directions（地点与方向）", "Sports & leisure (Continued)（运动与休闲 续）"], [
    {"en": "Today is the sports festival at our school. Everyone is excited.", "zh": "今天是我们学校的运动节。每个人都很兴奋。", "keywords": ["sport"]},
    {"en": "We play football, basketball and baseball on the field.", "zh": "我们在场地上踢足球、打篮球和棒球。", "keywords": ["play", "football", "basketball", "baseball"]},
    {"en": "I throw the ball to my friend. He catches it and runs.", "zh": "我把球扔给朋友。他接住球跑了起来。", "keywords": ["throw", "ball", "catch", "run"]},
    {"en": "Some students play table tennis and badminton in the gym.", "zh": "一些学生在体育馆里打乒乓球和羽毛球。", "keywords": ["table tennis", "badminton", "gym"]},
    {"en": "My hobby is swimming. I swim in the pool every week.", "zh": "我的爱好是游泳。我每周都在泳池里游泳。", "keywords": ["hobby", "swim"]},
    {"en": "We also play hockey and tennis. I need a tennis racket.", "zh": "我们还打曲棍球和网球。我需要一个网球拍。", "keywords": ["hockey", "tennis", "tennis racket"]},
    {"en": "I enjoy watching the game. The team with the most goals wins.", "zh": "我喜欢看比赛。进球最多的队伍获胜。", "keywords": ["enjoy", "game", "team"]},
    {"en": "I take a photo of the winner with my camera.", "zh": "我用相机给获胜者拍了一张照片。", "keywords": ["take a photo", "camera", "photo"]},
    {"en": "After the match, we watch television and listen to a song.", "zh": "比赛结束后，我们看电视，听一首歌。", "keywords": ["match", "television/TV", "song", "watch"]}
])

add("The Toy Shop", "红3", ["Sports & leisure (Continued)（运动与休闲 续）"], [
    {"en": "I went to the toy shop with my dad. There were so many toys!", "zh": "我和爸爸去了玩具店。那里有好多玩具！", "keywords": ["toy"]},
    {"en": "I saw a robot, a teddy bear and a monster doll.", "zh": "我看到了一个机器人、一只泰迪熊和一个怪物玩偶。", "keywords": ["robot", "teddy", "monster"]},
    {"en": "There was a helicopter and a plane hanging from the ceiling.", "zh": "天花板上挂着一架直升机和一架飞机。", "keywords": ["helicopter", "plane"]},
    {"en": "I wanted a kite and a bike, but they were too expensive.", "zh": "我想要一个风筝和一辆自行车，但它们太贵了。", "keywords": ["kite", "bike", "expensive"]},
    {"en": "My sister chose a doll and a board game. She loves puzzles.", "zh": "我姐姐选了一个洋娃娃和一个棋盘游戏。她喜欢拼图。", "keywords": ["doll", "board game", "puzzle"]},
    {"en": "I found a car, a lorry and a truck on the bottom shelf.", "zh": "我在底层架子上找到了一辆小汽车、一辆卡车和一辆大卡车。", "keywords": ["car", "lorry", "truck"]},
    {"en": "Dad bought me a football and a balloon. I was so happy!", "zh": "爸爸给我买了一个足球和一个气球。我太开心了！", "keywords": ["balloon"]},
    {"en": "We also got a boat and a train set. I will play with them at home.", "zh": "我们还买了一艘船和一套火车。我会在家里玩。", "keywords": ["boat", "train"]}
])

add("The Big Race", "红3", ["Sports & leisure (Continued)（运动与休闲 续）"], [
    {"en": "Last Saturday, there was a big race in our city.", "zh": "上周六，我们城市举办了一场大型比赛。", "keywords": ["race"]},
    {"en": "People came by bus, car and taxi. Some rode their bikes and motorbikes.", "zh": "人们坐公共汽车、小汽车和出租车来。有些人骑自行车和摩托车。", "keywords": ["bus", "taxi", "motorbike"]},
    {"en": "The racing cars were fast. They drove on the motorway to the stadium.", "zh": "赛车很快。它们在高速公路上开到体育场。", "keywords": ["racing", "motorway", "stadium"]},
    {"en": "We took the train to the railway station. Then we walked to the track.", "zh": "我们坐火车到火车站。然后走到赛道。", "keywords": ["railway", "platform"]},
    {"en": "The ambulance and fire engine were ready in case of an accident.", "zh": "救护车和消防车已经准备好以防事故。", "keywords": ["ambulance", "fire engine"]},
    {"en": "A ship passed by on the river. A rocket was painted on its side.", "zh": "一艘船从河上经过。船身上画着一枚火箭。", "keywords": ["ship", "rocket"]},
    {"en": "The traffic was heavy. Every passenger had to wait.", "zh": "交通很拥挤。每个乘客都必须等待。", "keywords": ["traffic", "passenger"]},
    {"en": "The winner got a tour of the city. The wheel of his car was golden.", "zh": "获胜者获得了一次城市之旅。他的车轮是金色的。", "keywords": ["tour", "wheel", "winner"]},
    {"en": "I want to drive a spaceship one day. That is my dream.", "zh": "我想有一天驾驶宇宙飞船。那是我的梦想。", "keywords": ["spaceship"]}
])

add("The Weather Report", "红3", ["Sports & leisure (Continued)（运动与休闲 续）"], [
    {"en": "Good morning! Here is today's weather report.", "zh": "早上好！这是今天的天气预报。", "keywords": []},
    {"en": "This morning, there is fog in the city. It is very foggy.", "zh": "今天早上，城市里有雾。非常雾蒙蒙的。", "keywords": ["fog", "foggy"]},
    {"en": "In the afternoon, there will be a storm with strong wind.", "zh": "下午会有暴风雨，风很大。", "keywords": ["storm", "afternoon"]},
    {"en": "The sun will come out in the evening. It will be a nice night.", "zh": "太阳会在傍晚出来。会是一个美好的夜晚。", "keywords": ["sun", "evening", "night"]},
    {"en": "Tomorrow morning will be warm. The clock says it is six a.m.", "zh": "明天早上会很暖和。时钟显示现在是早上六点。", "keywords": ["morning", "clock", "a.m.", "warm"]},
    {"en": "In the spring, flowers grow. In the summer, we go to the beach.", "zh": "春天，花儿开放。夏天，我们去海滩。", "keywords": ["spring", "summer", "beach"]},
    {"en": "In the autumn, leaves fall. In the winter, it snows.", "zh": "秋天，树叶飘落。冬天，下雪。", "keywords": ["autumn", "fall", "winter"]},
    {"en": "Today is a day in March. The date is the twenty-first.", "zh": "今天是三月的一天。日期是二十一号。", "keywords": ["day", "March", "date"]},
    {"en": "The calendar shows all the months: January, February, April, May, June.", "zh": "日历显示所有月份：一月、二月、四月、五月、六月。", "keywords": ["calendar", "February", "April", "May", "June"]},
    {"en": "July, August, September, October, November and December.", "zh": "七月、八月、九月、十月、十一月和十二月。", "keywords": ["July", "August", "September", "October", "November", "December"]}
])

add("The Birthday Party", "红3", ["Sports & leisure (Continued)（运动与休闲 续）", "Exclamations（感叹语）"], [
    {"en": "Today is my birthday! I am having a party this afternoon.", "zh": "今天是我的生日！我今天下午要开派对。", "keywords": ["birthday"]},
    {"en": "Hooray! All my friends are coming. Wow, there are so many presents!", "zh": "万岁！我所有的朋友都要来。哇，有好多礼物！", "keywords": ["Hooray!", "Wow!"]},
    {"en": "Amazing! My friend brought a violin and a drum.", "zh": "太棒了！我的朋友带来了一把小提琴和一面鼓。", "keywords": ["Amazing!", "violin", "drum"]},
    {"en": "Excellent! We played chess and did a quiz together.", "zh": "太好了！我们一起下棋和做问答游戏。", "keywords": ["Excellent!", "chess", "quiz"]},
    {"en": "We collected cards and read a magazine about pop music.", "zh": "我们收集卡片，看了一本关于流行音乐的杂志。", "keywords": ["collect", "magazine", "pop music"]},
    {"en": "My friend played the piano and sang a tune. Everyone danced.", "zh": "我的朋友弹钢琴唱了一首曲子。每个人都跳舞了。", "keywords": ["piano", "tune"]},
    {"en": "We watched a cartoon on a big screen. The channel was great.", "zh": "我们在大屏幕上看了一部动画片。频道很棒。", "keywords": ["cartoon", "channel"]},
    {"en": "See you next year! Bye everyone!", "zh": "明年见！大家再见！", "keywords": ["See you!", "bye"]},
    {"en": "Oh dear, I forgot to take a photo! No problem, we will take one next time.", "zh": "哦天哪，我忘了拍照！没关系，下次我们再拍。", "keywords": ["oh dear", "No problem!"]}
])

add("The Camping Trip", "红3", ["Sports & leisure (Continued)（运动与休闲 续）", "Adjectives（形容词）"], [
    {"en": "We went camping in the mountains last summer.", "zh": "去年夏天我们去山里露营了。", "keywords": ["camp"]},
    {"en": "We put up a tent and used a flashlight to see in the dark.", "zh": "我们搭起帐篷，用手电筒在黑暗中看路。", "keywords": ["tent", "flashlight", "dark"]},
    {"en": "The night was quiet. We could hear the sound of the stream.", "zh": "夜晚很安静。我们能听到小溪的声音。", "keywords": ["sound"]},
    {"en": "I was a little worried and frightening sounds came from the cave.", "zh": "我有点担心，洞穴里传来吓人的声音。", "keywords": ["worried", "frightening", "cave"]},
    {"en": "But it was just a small animal. How funny!", "zh": "但那只是一只小动物。多有趣！", "keywords": ["funny"]},
    {"en": "The view from the hill was enormous. We could see the whole land.", "zh": "从山丘上看到的景色非常壮观。我们能看到整片土地。", "keywords": ["view", "hill", "enormous", "land"]},
    {"en": "The air was fresh and the environment was beautiful.", "zh": "空气清新，环境优美。", "keywords": ["air", "environment"]},
    {"en": "We found a pond with stones around it. The water was deep.", "zh": "我们发现了一个周围有石头的池塘。水很深。", "keywords": ["pond", "stone", "deep"]},
    {"en": "It was an unusual and interesting experience. I felt lucky to be there.", "zh": "这是一次不寻常而有趣的经历。我觉得很幸运能在那里。", "keywords": ["unusual", "interesting", "lucky"]}
])


add("The Family Dinner", "红3", ["Food & drink（食物与饮料）", "Family & friends（家人与朋友）"], [
    {"en": "My husband and wife — I mean my mum and dad — are cooking dinner.", "zh": "我的丈夫和妻子——我是说我的爸爸妈妈——在做晚饭。", "keywords": ["husband", "wife"]},
    {"en": "We are having a big meal tonight. The whole family is here.", "zh": "今晚我们要吃一顿大餐。全家人都在。", "keywords": ["meal"]},
    {"en": "Mum cuts the strawberries with a knife. Dad adds salt and pepper.", "zh": "妈妈用刀切草莓。爸爸加盐和胡椒。", "keywords": ["strawberry", "knife", "salt", "pepper"]},
    {"en": "I eat a piece of pizza as a snack while I wait.", "zh": "我等的时候吃了一块比萨当零食。", "keywords": ["piece", "pizza", "snack"]},
    {"en": "The jam and yoghurt are on the table. The olives are in a bowl.", "zh": "果酱和酸奶在桌上。橄榄在碗里。", "keywords": ["jam", "yoghurt", "olives"]},
    {"en": "I use a spoon to eat the soup. It smells delicious.", "zh": "我用勺子喝汤。闻起来很香。", "keywords": ["spoon", "smell", "delicious"]},
    {"en": "The sugar is sweet. I can taste the chocolate in the cake.", "zh": "糖是甜的。我能尝到蛋糕里的巧克力味。", "keywords": ["sugar", "taste"]},
    {"en": "My surname is the same as my dad's. We are a married couple's children.", "zh": "我的姓和爸爸一样。我们是一对已婚夫妇的孩子。", "keywords": ["surname", "married"]}
])

add("The Science Museum", "红3", ["Places & directions（地点与方向）", "Nouns（名词）"], [
    {"en": "We went to the science museum in the north of the city.", "zh": "我们去了城市北部的科学博物馆。", "keywords": ["science", "north"]},
    {"en": "The museum is next to the bank and opposite the post office.", "zh": "博物馆在银行旁边，邮局对面。", "keywords": ["bank", "post office"]},
    {"en": "We walked past the police station and the fire station.", "zh": "我们走过了警察局和消防站。", "keywords": ["police station", "fire station"]},
    {"en": "The hotel is in the south, near the theatre.", "zh": "酒店在南边，靠近剧院。", "keywords": ["hotel", "south", "theatre"]},
    {"en": "I saw a design of an engine. It was very interesting.", "zh": "我看到了一个引擎的设计。非常有趣。", "keywords": ["design", "engine"]},
    {"en": "There was information about money from different countries.", "zh": "有关于不同国家货币的信息。", "keywords": ["information", "money"]},
    {"en": "I bought a postcard at the shop. I also got a dictionary.", "zh": "我在商店买了一张明信片。我还买了一本字典。", "keywords": ["postcard", "dictionary"]},
    {"en": "The factory in the west makes robots. The skyscraper is very tall.", "zh": "西边的工厂制造机器人。摩天大楼非常高。", "keywords": ["factory", "west", "skyscraper"]},
    {"en": "We need to get to the club before it closes. The way is to the left.", "zh": "我们需要在俱乐部关门前到达。路在左边。", "keywords": ["club", "get to", "way", "left"]}
])

add("The Lazy Sunday", "红3", ["Adjectives（形容词）"], [
    {"en": "It was a lazy Sunday. I stayed in bed until late.", "zh": "这是一个懒洋洋的星期天。我在床上待到很晚。", "keywords": ["lazy", "late"]},
    {"en": "My room was untidy. Mum said: Please tidy your room!", "zh": "我的房间很乱。妈妈说：请整理你的房间！", "keywords": ["untidy"]},
    {"en": "I was bored and a little bit hungry.", "zh": "我很无聊，有点饿。", "keywords": ["bored"]},
    {"en": "The food was cheap but delicious. I was pleased.", "zh": "食物便宜但好吃。我很满意。", "keywords": ["cheap"]},
    {"en": "My friend is unfriendly sometimes, but today she was nice.", "zh": "我的朋友有时候不太友好，但今天她很好。", "keywords": ["unfriendly", "nice"]},
    {"en": "The old house looked horrible from the front, but lovely inside.", "zh": "老房子从正面看很可怕，但里面很可爱。", "keywords": ["horrible", "front"]},
    {"en": "I felt interested in the new book. It was about a poor boy who became rich.", "zh": "我对新书很感兴趣。它讲的是一个穷男孩变富的故事。", "keywords": ["interested", "poor", "rich"]},
    {"en": "The story was popular and important. Everyone should read it.", "zh": "这个故事很受欢迎，也很重要。每个人都应该读。", "keywords": ["popular", "important"]},
    {"en": "I was ready to go out. The weather was warm and the sky was clear.", "zh": "我准备好出门了。天气暖和，天空晴朗。", "keywords": ["ready"]},
    {"en": "It was a good day. Not the same as yesterday, but still lovely.", "zh": "这是美好的一天。和昨天不一样，但仍然很美好。", "keywords": ["good", "same"]}
])

add("The Missing Cat", "红3", ["Adjectives（形容词）", "Verbs – regular（规则动词）"], [
    {"en": "My cat is missing! I need to look for her everywhere.", "zh": "我的猫不见了！我需要到处找她。", "keywords": ["missing", "look at"]},
    {"en": "I love my cat. She is my favourite pet.", "zh": "我爱我的猫。她是我最喜欢的宠物。", "keywords": ["love", "favourite"]},
    {"en": "I started to look around the house. I wanted to find her.", "zh": "我开始在房子周围找。我想找到她。", "keywords": ["start", "want"]},
    {"en": "I pointed at the garden and said: Let us look there!", "zh": "我指着花园说：我们去那里找！", "keywords": ["point"]},
    {"en": "My friend agreed to help. She showed me where to look.", "zh": "我的朋友同意帮忙。她给我看了该找的地方。", "keywords": ["agree", "show"]},
    {"en": "We stopped to talk to the neighbour. He waved at us.", "zh": "我们停下来和邻居说话。他向我们挥手。", "keywords": ["stop", "talk", "wave"]},
    {"en": "I like to paint pictures of my cat. She looks like a little tiger.", "zh": "我喜欢画我的猫的画。她看起来像一只小老虎。", "keywords": ["like", "paint", "look like"]},
    {"en": "Suddenly, I heard a sound. I picked up a box and there she was!", "zh": "突然，我听到一个声音。我拿起一个盒子，她就在那里！", "keywords": ["pick up"]},
    {"en": "I thanked my friend. We hugged and I felt so happy.", "zh": "我感谢了我的朋友。我们拥抱了，我感到非常开心。", "keywords": ["thank"]}
])

add("The School Subjects", "红3", ["Places & directions（地点与方向）"], [
    {"en": "I study many subjects at school. My favourite is geography.", "zh": "我在学校学很多科目。我最喜欢的是地理。", "keywords": ["subject", "geography", "school"]},
    {"en": "In maths class, we learn about numbers and shapes.", "zh": "在数学课上，我们学习数字和形状。", "keywords": ["maths", "number"]},
    {"en": "History is interesting. We learn about old kings and queens.", "zh": "历史很有趣。我们学习古代的国王和王后。", "keywords": ["history"]},
    {"en": "In science, we do experiments. The student must be careful.", "zh": "在科学课上，我们做实验。学生必须小心。", "keywords": ["student", "study"]},
    {"en": "I use a dictionary to learn new words in my language class.", "zh": "我在语言课上用字典学习新单词。", "keywords": ["language"]},
    {"en": "The timetable shows all our classes. We have gym on Monday.", "zh": "课程表显示了我们所有的课。我们周一有体育课。", "keywords": ["timetable"]},
    {"en": "I carry my rucksack to school every day. It is very heavy.", "zh": "我每天背着背包去上学。它非常重。", "keywords": ["rucksack", "heavy"]},
    {"en": "We have a flag in front of the school. It is red and blue.", "zh": "学校前面有一面旗帜。它是红蓝色的。", "keywords": ["flag"]},
    {"en": "I am online every evening to study. I use the school website.", "zh": "我每天晚上都上网学习。我用学校的网站。", "keywords": ["online"]}
])

add("The Cooking Class", "红3", ["Verbs – regular（规则动词）", "The home（家与家居）"], [
    {"en": "Today we had a cooking class. The teacher explained the recipe.", "zh": "今天我们上了一节烹饪课。老师解释了食谱。", "keywords": ["explain"]},
    {"en": "First, we had to prepare all the ingredients.", "zh": "首先，我们必须准备好所有的食材。", "keywords": ["prepare"]},
    {"en": "I used a brush to clean the cooker. Then I put the cushion on the chair.", "zh": "我用刷子清洁了炉灶。然后我把靠垫放在椅子上。", "keywords": ["brush", "cooker", "cushion"]},
    {"en": "We had to mix the flour and push the dough flat.", "zh": "我们必须搅拌面粉，把面团压平。", "keywords": ["mix", "push"]},
    {"en": "I used a comb to — wait, that is for hair! I used a fork instead.", "zh": "我用梳子——等等，那是梳头发的！我改用叉子。", "keywords": ["comb"]},
    {"en": "We had to pull the bread apart and touch it to check if it was ready.", "zh": "我们必须把面包掰开，摸一摸看是否做好了。", "keywords": ["pull", "touch"]},
    {"en": "I decided to follow the recipe carefully. I did not want to make a mistake.", "zh": "我决定仔细按照食谱做。我不想犯错。", "keywords": ["decide", "follow"]},
    {"en": "The entrance to the kitchen was small. We had to enter one by one.", "zh": "厨房的入口很小。我们必须一个一个进去。", "keywords": ["entrance", "enter"]},
    {"en": "I turned on the oven and turned off the light. The soap was near the sink.", "zh": "我打开烤箱，关掉灯。肥皂在水槽旁边。", "keywords": ["turn on", "turn off", "soap"]}
])


add("The Verbs Challenge", "红3", ["Verbs – irregular（不规则动词）", "Verbs – regular（规则动词）"], [
    {"en": "Let's play a game! I will say a verb and you do the action.", "zh": "我们来玩个游戏！我说一个动词，你做动作。", "keywords": ["let's"]},
    {"en": "Can you hold this book? Now give it to your friend.", "zh": "你能拿着这本书吗？现在把它给你的朋友。", "keywords": ["hold", "give"]},
    {"en": "I said: Put the pen on the desk. He said: I can do that!", "zh": "我说：把笔放在桌上。他说：我能做到！", "keywords": ["put", "say", "can"]},
    {"en": "She began to speak loudly. Everyone could hear her.", "zh": "她开始大声说话。每个人都能听到她。", "keywords": ["begin", "speak", "hear"]},
    {"en": "I had to make sure I did not forget the rules.", "zh": "我必须确保我没有忘记规则。", "keywords": ["make sure", "forget"]},
    {"en": "He broke the pencil by accident. She felt sorry about it.", "zh": "他不小心弄断了铅笔。她为此感到抱歉。", "keywords": ["break", "feel"]},
    {"en": "I would like to go to sleep now. I am very tired.", "zh": "我现在想去睡觉了。我很累。", "keywords": ["would like", "go to sleep"]},
    {"en": "Let me see your drawing. I want to look at it carefully.", "zh": "让我看看你的画。我想仔细看看。", "keywords": ["let", "see"]},
    {"en": "I have got a new pen. I will keep it in my bag.", "zh": "我有了一支新笔。我会把它放在书包里。", "keywords": ["have got", "keep"]},
    {"en": "She left the room and went out to find her friend.", "zh": "她离开了房间，出去找她的朋友。", "keywords": ["leave", "go out", "find out"]}
])

add("The Repair Shop", "红3", ["Verbs – regular（规则动词）"], [
    {"en": "My dad has a repair shop. He fixes broken things.", "zh": "我爸爸有一个修理店。他修理坏掉的东西。", "keywords": ["repair"]},
    {"en": "Today, someone brought a broken bicycle to the shop.", "zh": "今天，有人带了一辆坏掉的自行车来店里。", "keywords": ["bicycle"]},
    {"en": "Dad said: I hope I can fix it. Let me look at it.", "zh": "爸爸说：我希望我能修好它。让我看看。", "keywords": ["hope"]},
    {"en": "He had to lift the bike and turn it upside down.", "zh": "他必须把自行车抬起来翻过来。", "keywords": ["lift", "turn"]},
    {"en": "I helped him fetch the tools. We worked together.", "zh": "我帮他拿工具。我们一起工作。", "keywords": ["fetch"]},
    {"en": "He asked me to repeat the instructions. I had to remember every step.", "zh": "他让我重复说明。我必须记住每一步。", "keywords": ["repeat", "remember"]},
    {"en": "We finished the repair and saved the customer a lot of money.", "zh": "我们完成了修理，为顾客省了很多钱。", "keywords": ["finish", "save"]},
    {"en": "I whispered to dad: Can I borrow your tools? He said: Of course!", "zh": "我悄悄对爸爸说：我能借你的工具吗？他说：当然！", "keywords": ["whisper", "borrow"]},
    {"en": "I want to invent something new. Maybe I will improve the design.", "zh": "我想发明一些新东西。也许我会改进设计。", "keywords": ["invent", "improve"]},
    {"en": "Dad whistled a happy tune. He loves his job.", "zh": "爸爸吹着欢快的口哨。他热爱他的工作。", "keywords": ["whistle"]},
    {"en": "I wished I could stay longer, but I had to hurry home.", "zh": "我希望我能待久一点，但我必须赶紧回家。", "keywords": ["wish", "hurry"]},
    {"en": "I will visit the shop again tomorrow. I hate to miss a day there.", "zh": "我明天会再来店里。我讨厌错过在那里的一天。", "keywords": ["visit", "hate"]}
])

add("The IT Lesson", "红3", ["IT（信息技术）", "Places & directions（地点与方向）"], [
    {"en": "Today we had an IT lesson at school.", "zh": "今天我们在学校上了一节信息技术课。", "keywords": []},
    {"en": "The teacher showed us how to use a tablet.", "zh": "老师教我们如何使用平板电脑。", "keywords": ["tablet"]},
    {"en": "We learned how to open and close a file on the computer.", "zh": "我们学习了如何在电脑上打开和关闭文件。", "keywords": ["open/close a file"]},
    {"en": "There was a programme that helped us search for information.", "zh": "有一个程序帮助我们搜索信息。", "keywords": ["programme", "search"]},
    {"en": "We needed wifi to connect to the internet.", "zh": "我们需要无线网络来连接互联网。", "keywords": ["wifi"]},
    {"en": "I wrote a story on the computer. The part about the adventure was the best.", "zh": "我在电脑上写了一个故事。关于冒险的部分是最好的。", "keywords": ["story", "part"]},
    {"en": "The teacher said: Look at the screen and draw a picture.", "zh": "老师说：看屏幕，画一幅画。", "keywords": ["drawing"]},
    {"en": "I used the mouse to click and the keyboard to type.", "zh": "我用鼠标点击，用键盘打字。", "keywords": ["mouse"]}
])

add("The Nature Walk", "红3", ["Sports & leisure (Continued)（运动与休闲 续）", "Animals（动物）"], [
    {"en": "We went on a nature walk through the forest.", "zh": "我们在森林里进行了一次自然漫步。", "keywords": ["walk"]},
    {"en": "I saw a swan swimming in the pond. It was very beautiful.", "zh": "我看到一只天鹅在池塘里游泳。非常美丽。", "keywords": ["swan"]},
    {"en": "A tortoise was walking slowly on the path. An octopus was in the aquarium nearby.", "zh": "一只乌龟在小路上慢慢走。附近的水族馆里有一只章鱼。", "keywords": ["tortoise", "octopus"]},
    {"en": "We found a bird's nest in the tree. There were eggs inside.", "zh": "我们在树上发现了一个鸟巢。里面有蛋。", "keywords": ["nest"]},
    {"en": "An insect with colourful wings flew past us.", "zh": "一只有着彩色翅膀的昆虫飞过我们身边。", "keywords": ["insect", "wing"]},
    {"en": "The wild animals live in the forest. We should not disturb them.", "zh": "野生动物住在森林里。我们不应该打扰它们。", "keywords": ["wild"]},
    {"en": "We sat on the sand by the sea and watched the waves.", "zh": "我们坐在海边的沙滩上看海浪。", "keywords": ["sand", "sea"]},
    {"en": "I found a beautiful shell on the beach. The street back home was quiet.", "zh": "我在海滩上找到了一个美丽的贝壳。回家的街道很安静。", "keywords": ["shell", "street"]},
    {"en": "The water in the stream was clear. The Earth is a beautiful planet.", "zh": "小溪里的水很清澈。地球是一个美丽的星球。", "keywords": ["stream", "Earth", "planet"]},
    {"en": "We saw a pyramid in a book about the desert. The ocean is so big!", "zh": "我们在一本关于沙漠的书里看到了金字塔。海洋好大！", "keywords": ["pyramid", "desert", "ocean"]}
])

add("The Costume Uniform Day", "红3", ["Clothes（衣物）", "Exclamations（感叹语）"], [
    {"en": "Today is costume day at school. We do not wear our uniform.", "zh": "今天是学校的变装日。我们不穿校服。", "keywords": ["uniform"]},
    {"en": "I wear my cool sunglasses and new trainers.", "zh": "我戴上酷酷的太阳镜，穿上新运动鞋。", "keywords": ["sunglasses", "trainers"]},
    {"en": "My friend wears pajamas and carries an umbrella. How funny!", "zh": "我的朋友穿着睡衣，拿着一把雨伞。多有趣！", "keywords": ["pajamas", "umbrella"]},
    {"en": "She has a beautiful ring on her finger.", "zh": "她手指上戴着一枚漂亮的戒指。", "keywords": ["ring"]},
    {"en": "If you want, you can dress up as anything!", "zh": "如果你想的话，你可以打扮成任何东西！", "keywords": ["If you want!"]},
    {"en": "Go away, rain! We want to play outside!", "zh": "走开，雨！我们想在外面玩！", "keywords": ["Go away!"]},
    {"en": "In a minute, the show will start. You're welcome to join us!", "zh": "马上表演就要开始了。欢迎你加入我们！", "keywords": ["In a minute!", "you're welcome"]},
    {"en": "The teacher said: Fantastic! Everyone looks wonderful today.", "zh": "老师说：太棒了！今天每个人看起来都很棒。", "keywords": ["fantastic"]}
])

add("The Jobs Fair", "红3", ["Sports & leisure (Continued)（运动与休闲 续）"], [
    {"en": "Our school had a jobs fair. Many people came to talk about their work.", "zh": "我们学校举办了一场职业博览会。很多人来谈论他们的工作。", "keywords": ["job"]},
    {"en": "The actor told us about working on stage. The artist showed us her paintings.", "zh": "演员告诉我们在舞台上工作的事。艺术家给我们看了她的画。", "keywords": ["actor", "artist", "stage"]},
    {"en": "The astronaut talked about going to space in a rocket.", "zh": "宇航员谈到了乘火箭去太空。", "keywords": ["astronaut", "space"]},
    {"en": "A businessman told us about his business. The manager runs a big office.", "zh": "一位商人告诉我们他的生意。经理管理一个大办公室。", "keywords": ["business", "businessman/woman", "manager", "office"]},
    {"en": "The designer showed us her latest design. The engineer built a model.", "zh": "设计师给我们看了她最新的设计。工程师搭建了一个模型。", "keywords": ["designer", "engineer"]},
    {"en": "The firefighter drove a fire engine. The pilot flew a plane.", "zh": "消防员开消防车。飞行员开飞机。", "keywords": ["firefighter", "pilot"]},
    {"en": "The journalist wrote for a newspaper. The photographer took photos.", "zh": "记者为报纸写稿。摄影师拍照。", "keywords": ["journalist", "newspaper", "photographer"]},
    {"en": "The mechanic fixed cars. The police officer kept people safe.", "zh": "机械师修理汽车。警察保护人们的安全。", "keywords": ["mechanic", "police officer"]},
    {"en": "The singer sang a beautiful song. The waiter served food at the meeting.", "zh": "歌手唱了一首美丽的歌。服务员在会议上端食物。", "keywords": ["singer", "waiter", "meeting", "news"]},
    {"en": "The queen visited our school! She arrived in a big car.", "zh": "女王参观了我们的学校！她坐着一辆大车到达。", "keywords": ["queen", "arrive"]}
])

add("The Adverb Adventure", "红3", ["Adverbs（副词）", "Adverbs (Continued)（副词 续）"], [
    {"en": "I really like adventures. Today I went on a very special one.", "zh": "我真的很喜欢冒险。今天我进行了一次非常特别的冒险。", "keywords": ["really", "very"]},
    {"en": "I woke up early and said yes to the trip. Not everyone wanted to go.", "zh": "我早早醒来，对旅行说了好。不是每个人都想去。", "keywords": ["early", "yes", "not"]},
    {"en": "We went home first, then came back here to start.", "zh": "我们先回家，然后回到这里出发。", "keywords": ["home", "here"]},
    {"en": "I had a lot of things to carry. There were lots of bags too.", "zh": "我有很多东西要拿。也有很多包。", "keywords": ["a lot", "lots"]},
    {"en": "We walked fast and hard. Soon we were far from the city.", "zh": "我们走得又快又辛苦。很快我们就离城市很远了。", "keywords": ["fast", "hard", "far"]},
    {"en": "I said: Perhaps we should rest. My friend said: Not yet!", "zh": "我说：也许我们应该休息。我的朋友说：还没有！", "keywords": ["perhaps", "yet"]},
    {"en": "We were quite tired but still happy. We walked straight on.", "zh": "我们相当累但仍然开心。我们一直往前走。", "keywords": ["quite", "still", "straight on"]},
    {"en": "Suddenly, we found a beautiful lake. We had never been there before.", "zh": "突然，我们发现了一个美丽的湖。我们以前从未去过那里。", "keywords": ["suddenly", "there", "before"]},
    {"en": "We will come again tomorrow. Tonight we rest. Now I go to sleep.", "zh": "我们明天再来。今晚我们休息。现在我去睡觉。", "keywords": ["again", "tomorrow", "tonight", "now"]},
    {"en": "I usually go on adventures by myself, but today I went together with friends.", "zh": "我通常独自去冒险，但今天我和朋友们一起去了。", "keywords": ["usually", "by myself", "together"]},
    {"en": "I already feel much better. I also want to go somewhere else next time.", "zh": "我已经感觉好多了。我下次还想去别的地方。", "keywords": ["already", "also", "somewhere", "else", "much", "next"]},
    {"en": "It was just a little walk, but it felt like a big adventure. Once is not enough!", "zh": "这只是一次小小的散步，但感觉像一次大冒险。一次是不够的！", "keywords": ["just", "a little", "once"]},
    {"en": "I looked everywhere but found nowhere to sit. So I sat over there instead.", "zh": "我到处看但找不到地方坐。所以我改坐在那边。", "keywords": ["everywhere", "nowhere", "over", "instead"]},
    {"en": "How long did the trip take? Actually, not very long at all.", "zh": "旅行花了多长时间？实际上，一点也不长。", "keywords": ["how long", "actually"]},
    {"en": "I can go anywhere I want. At the moment, I am happy right here.", "zh": "我可以去任何我想去的地方。此刻，我就在这里很开心。", "keywords": ["anywhere", "at the moment"]},
    {"en": "It happened a long time ago, but I still remember it. Later, I will write about it.", "zh": "这发生在很久以前，但我仍然记得。之后，我会写下来。", "keywords": ["ago", "later"]},
    {"en": "I said no to staying home today. I am so glad I went out.", "zh": "我今天拒绝了待在家里。我很高兴我出去了。", "keywords": ["no", "today", "so"]},
    {"en": "I will go away soon and come back after lunch.", "zh": "我很快就要走了，午饭后回来。", "keywords": ["away", "soon", "after"]}
])


add("The Snowball Fight", "红3", ["Sports & leisure (Continued)（运动与休闲 续）"], [
    {"en": "It was a cold winter day. We decided to have a snowball fight.", "zh": "这是一个寒冷的冬天。我们决定打雪仗。", "keywords": ["snowball"]},
    {"en": "First, we built a snowman in the garden. He had a big smile.", "zh": "首先，我们在花园里堆了一个雪人。他有一个大大的微笑。", "keywords": ["snowman"]},
    {"en": "My friend brought a sledge. We went sledging down the hill.", "zh": "我的朋友带了一个雪橇。我们从山上滑雪橇下来。", "keywords": ["sledge"]},
    {"en": "Some kids went skiing. Others tried snowboarding.", "zh": "一些孩子去滑雪了。其他人尝试了单板滑雪。", "keywords": ["ski", "snowboarding", "snowboard"]},
    {"en": "We played golf in the snow — just for fun!", "zh": "我们在雪地里打高尔夫——只是为了好玩！", "keywords": ["golf"]},
    {"en": "I brought my suitcase with warm clothes. My friend had a swing in his garden.", "zh": "我带了装满暖和衣服的行李箱。我的朋友花园里有一个秋千。", "keywords": ["suitcase", "swing"]},
    {"en": "We used a torch to find our way home in the dark.", "zh": "我们用手电筒在黑暗中找到回家的路。", "keywords": ["torch"]},
    {"en": "The tyre of my bike was flat. I had to walk home.", "zh": "我自行车的轮胎瘪了。我只好走路回家。", "keywords": ["tyre"]},
    {"en": "We joined a volleyball game at the sports centre.", "zh": "我们在体育中心参加了一场排球比赛。", "keywords": ["join", "volleyball"]}
])

add("The Concert Night", "红3", ["Sports & leisure (Continued)（运动与休闲 续）"], [
    {"en": "Last night, we went to a concert in the city.", "zh": "昨晚，我们去城里看了一场音乐会。", "keywords": ["concert"]},
    {"en": "The band played rock music and pop music. Everyone danced.", "zh": "乐队演奏了摇滚乐和流行乐。每个人都跳舞了。", "keywords": ["rock music"]},
    {"en": "I got an invitation from my friend. She is a member of the fan club.", "zh": "我收到了朋友的邀请。她是粉丝俱乐部的成员。", "keywords": ["invitation", "member"]},
    {"en": "We met at the entrance and found our seats.", "zh": "我们在入口处见面，找到了我们的座位。", "keywords": ["meet", "entrance", "exit"]},
    {"en": "The festival was amazing. There was an instrument display too.", "zh": "音乐节太棒了。还有乐器展示。", "keywords": ["festival", "instrument"]},
    {"en": "After the concert, we took a lift to the top floor.", "zh": "音乐会结束后，我们坐电梯到了顶楼。", "keywords": ["lift"]},
    {"en": "We could see the fire in the distance and the water of the river.", "zh": "我们能看到远处的火光和河水。", "keywords": ["fire", "water"]},
    {"en": "The journey home was long. We took a taxi.", "zh": "回家的路很长。我们坐了出租车。", "keywords": ["journey"]},
    {"en": "I bounced with excitement all the way home. What a night!", "zh": "我一路上兴奋地蹦蹦跳跳。多么美好的夜晚！", "keywords": ["bounce"]}
])

add("The Time Machine", "红3", ["Sports & leisure (Continued)（运动与休闲 续）"], [
    {"en": "I read a story about a time machine. It could travel to the future.", "zh": "我读了一个关于时间机器的故事。它能穿越到未来。", "keywords": ["future"]},
    {"en": "The clock showed midnight. It was exactly twelve p.m.", "zh": "时钟显示午夜。正好是晚上十二点。", "keywords": ["midnight", "p.m."]},
    {"en": "At midday, the machine started. It took about a quarter of an hour.", "zh": "中午，机器启动了。大约花了一刻钟。", "keywords": ["midday", "quarter", "hour"]},
    {"en": "In one minute, we were in a new century. Time passed quickly.", "zh": "一分钟内，我们到了一个新世纪。时间过得很快。", "keywords": ["minute", "century"]},
    {"en": "In the future, there were aliens and monsters everywhere.", "zh": "在未来，到处都是外星人和怪物。", "keywords": ["alien"]},
    {"en": "We saw a skateboarding robot playing soccer with a ball.", "zh": "我们看到一个滑板机器人在踢足球。", "keywords": ["skateboarding", "soccer"]},
    {"en": "People flew in helicopters and drove flying cars.", "zh": "人们坐直升机飞行，开飞行汽车。", "keywords": ["fly", "drive"]},
    {"en": "I took a photo and watched the scene on my watch.", "zh": "我拍了一张照片，在手表上看着这个场景。", "keywords": ["year"]},
    {"en": "We had to go back before the end of the day.", "zh": "我们必须在一天结束前回去。", "keywords": ["end"]},
    {"en": "It was half past three when we returned. What an adventure!", "zh": "我们回来时是三点半。多么精彩的冒险！", "keywords": ["half", "past"]}
])

add("The Treasure Island", "红3", ["Sports & leisure (Continued)（运动与休闲 续）", "Adjectives（形容词）"], [
    {"en": "We found a map that led to a treasure on an island.", "zh": "我们找到了一张通往岛上宝藏的地图。", "keywords": []},
    {"en": "The island was big and full of trees. The path was long.", "zh": "岛很大，到处是树。路很长。", "keywords": ["big", "full", "long"]},
    {"en": "We had to be brave. The forest was dark and noisy.", "zh": "我们必须勇敢。森林又暗又吵。", "keywords": ["noisy"]},
    {"en": "I felt a soft wind on my face. The ground was hard and dry.", "zh": "我感到脸上有一阵柔和的风。地面又硬又干。", "keywords": ["soft"]},
    {"en": "The treasure was in a high place. We had to climb a low wall first.", "zh": "宝藏在一个高处。我们必须先爬过一堵矮墙。", "keywords": ["high", "low"]},
    {"en": "My friend was short but strong. She helped me climb.", "zh": "我的朋友个子矮但很强壮。她帮我爬上去。", "keywords": ["short"]},
    {"en": "The box was heavy and large. Inside were old coins.", "zh": "箱子又重又大。里面是古老的硬币。", "keywords": ["large"]},
    {"en": "We were so happy! It was a new and exciting discovery.", "zh": "我们太开心了！这是一个新的、令人兴奋的发现。", "keywords": ["new", "excited"]},
    {"en": "The small hole in the ground led to a secret room.", "zh": "地上的小洞通向一个秘密房间。", "keywords": ["small", "hole"]},
    {"en": "I felt sore from all the walking, but it was worth it.", "zh": "走了这么多路我感觉酸痛，但值得。", "keywords": ["sore"]}
])

add("The Pen Pal Letter", "红3", ["Verbs – irregular（不规则动词）", "Verbs – regular（规则动词）"], [
    {"en": "I like to write letters to my pen pal. She lives far away.", "zh": "我喜欢给笔友写信。她住得很远。", "keywords": ["write"]},
    {"en": "I told her: I have a new pet. She said: That is wonderful!", "zh": "我告诉她：我有了一只新宠物。她说：太好了！", "keywords": ["have"]},
    {"en": "She asked me to post the letter. I put a stamp on the envelope.", "zh": "她让我寄信。我在信封上贴了邮票。", "keywords": ["post", "stamp"]},
    {"en": "I had to spend time writing carefully. I did not want to make a mistake.", "zh": "我必须花时间仔细写。我不想犯错。", "keywords": ["spend"]},
    {"en": "She told me she could sell her old books. I wanted to buy them.", "zh": "她告诉我她可以卖掉旧书。我想买。", "keywords": ["sell"]},
    {"en": "I burned my finger while cooking. She said: Be careful!", "zh": "我做饭时烫了手指。她说：小心！", "keywords": ["burn"]},
    {"en": "She appeared at my door one day. I was so surprised!", "zh": "有一天她出现在我家门口。我太惊讶了！", "keywords": ["appear"]},
    {"en": "She said: I believe we will be friends forever.", "zh": "她说：我相信我们会永远是朋友。", "keywords": ["believe"]},
    {"en": "I took her to explore the city. We cycled around the park.", "zh": "我带她去探索城市。我们在公园里骑车。", "keywords": ["explore", "cycle"]},
    {"en": "She chatted with everyone. She did not mind the rain.", "zh": "她和每个人聊天。她不介意下雨。", "keywords": ["chat", "mind"]},
    {"en": "I looked after her during the visit. We stayed together all week.", "zh": "我在她来访期间照顾她。我们整周都在一起。", "keywords": ["look after", "stay"]},
    {"en": "She disappeared on the last day. Then I found her at the bus stop!", "zh": "最后一天她消失了。然后我在公交站找到了她！", "keywords": ["disappear"]},
    {"en": "She said: I will win a competition one day. I said: I am sure you will!", "zh": "她说：我总有一天会赢得比赛。我说：我相信你会的！", "keywords": ["win a competition", "sure"]}
])

add("The Home Makeover", "红3", ["The home (Continued)（家与家居 续）", "The home（家与家居）"], [
    {"en": "We are making our home look new. Mum bought some soap and a telephone.", "zh": "我们正在让家焕然一新。妈妈买了一些肥皂和一部电话。", "keywords": ["telephone"]},
    {"en": "I walked up the steps to the second floor.", "zh": "我走上台阶到了二楼。", "keywords": ["step"]},
    {"en": "There is a swing in the garden for my little sister.", "zh": "花园里有一个给我小妹妹的秋千。", "keywords": ["swing"]},
    {"en": "I put wool blankets on every bed. They are warm and soft.", "zh": "我在每张床上放了羊毛毯子。它们又暖和又柔软。", "keywords": ["wool"]},
    {"en": "The stamp collection is on the shelf. The letter is on the table.", "zh": "邮票收藏在架子上。信在桌上。", "keywords": ["stamp"]},
    {"en": "I used a brush to paint the wall. The colour is light blue.", "zh": "我用刷子刷墙。颜色是浅蓝色。", "keywords": ["light"]},
    {"en": "The thing I like most is the new painting in the hall.", "zh": "我最喜欢的东西是走廊里的新画。", "keywords": ["thing"]},
    {"en": "I made a bit of a mess, but it was fun.", "zh": "我弄得有点乱，但很有趣。", "keywords": ["bit"]}
])

# ============================================================
# Merge and save
# ============================================================

articles_data['articles'].extend(new_articles)
articles_data['version'] = "2.0"

with open('flutter_app/assets/articles.json', 'w', encoding='utf-8') as f:
    json.dump(articles_data, f, ensure_ascii=False, indent=2)

print(f"Total articles: {len(articles_data['articles'])}")
print(f"New articles added: {len(new_articles)}")
