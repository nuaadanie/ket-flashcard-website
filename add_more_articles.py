#!/usr/bin/env python3
"""Add more articles to cover remaining uncovered words."""
import json

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

# 蓝2 remaining words
add("The Birthday Party", "蓝2", ["Adjectives（形容词）", "Verbs – irregular（不规则动词）", "Places & directions（地点与方向）"], [
    {"en": "It was my birthday party at the supermarket cafe.", "zh": "我的生日派对在超市的咖啡厅举行。", "keywords": ["party", "supermarket"]},
    {"en": "My friend is called Jane. She has blond hair and a fair face.", "zh": "我的朋友叫简。她有金色的头发和白皙的脸。", "keywords": ["be called", "blond(e)", "fair"]},
    {"en": "She could skate very well. She would always win the race.", "zh": "她滑冰滑得很好。她总是赢得比赛。", "keywords": ["could", "skate", "would"]},
    {"en": "I must get off the bus at the city centre. Then I take a taxi.", "zh": "我必须在市中心下车。然后坐出租车。", "keywords": ["must", "get off", "city/town centre"]},
    {"en": "The terrible weather made us stay inside. It was another rainy day.", "zh": "糟糕的天气让我们待在室内。又是一个下雨天。", "keywords": ["terrible", "another"]},
    {"en": "Shall we go fishing? Any place is fine with me.", "zh": "我们去钓鱼好吗？任何地方都行。", "keywords": ["shall", "fish", "any"]},
    {"en": "I have to dress up for the party. I mean, it is a special day!", "zh": "我必须为派对打扮。我的意思是，这是特别的一天！", "keywords": ["dress up", "mean"]},
    {"en": "At three o'clock, we sat in a circle and played games.", "zh": "三点钟，我们围成一圈玩游戏。", "keywords": ["o'clock", "circle"]},
    {"en": "Then we had a break. I watered the flowers in the garden.", "zh": "然后我们休息了一下。我给花园里的花浇了水。", "keywords": ["break", "water"]},
    {"en": "The president of our class gave a speech. Brilliant!", "zh": "我们班长发表了讲话。太棒了！", "keywords": ["president", "Brilliant!"]},
    {"en": "Most people had fun. What is your age? I am ten years old.", "zh": "大多数人都玩得很开心。你多大了？我十岁了。", "keywords": ["most", "age"]},
    {"en": "It was better than last year. I have many happy memories.", "zh": "比去年好。我有很多快乐的回忆。", "keywords": ["than", "have", "then"]},
    {"en": "I took many photos on my phone.", "zh": "我用手机拍了很多照片。", "keywords": ["take"]}
])

# 红3 remaining meaningful words
add("The Sports Day", "红3", ["Places & directions（地点与方向）", "Sports & leisure (Continued)（运动与休闲 续）"], [
    {"en": "Today is Sports Day. We play many sports at school.", "zh": "今天是运动日。我们在学校做很多运动。", "keywords": ["Sports"]},
    {"en": "I hit the ball with a bat. Then I jumped over the line.", "zh": "我用球棒击球。然后我跳过了线。", "keywords": ["hit", "bat", "jump"]},
    {"en": "We went fishing by the river. I kicked the ball and scored a goal.", "zh": "我们去河边钓鱼了。我踢球进了一个球。", "keywords": ["fishing", "kick", "score"]},
    {"en": "I crossed the finish line first. I learned to never give up.", "zh": "我第一个冲过终点线。我学会了永不放弃。", "keywords": ["cross", "learn"]},
    {"en": "The alphabet of sports: A for athletics, B for basketball.", "zh": "运动的字母表：A代表田径，B代表篮球。", "keywords": ["alphabet"]},
    {"en": "I asked my friend: Do you understand the rules?", "zh": "我问朋友：你理解规则吗？", "keywords": ["ask", "understand"]},
    {"en": "London is a great city for sports. It is about 100 kilometres away.", "zh": "伦敦是一个很棒的运动城市。它大约在100公里外。", "keywords": ["London", "kilometre"]},
    {"en": "The middle of the field is where we start. Go!", "zh": "场地中间是我们出发的地方。走！", "keywords": ["middle", "go"]}
])

add("The Colourful World", "红3", ["Adjectives（形容词）"], [
    {"en": "My world is colourful. I see black cats and blue skies.", "zh": "我的世界是多彩的。我看到黑猫和蓝天。", "keywords": ["black", "blue"]},
    {"en": "The brown dog plays with the white rabbit.", "zh": "棕色的狗和白色的兔子一起玩。", "keywords": ["brown", "white"]},
    {"en": "My sister wears a pink dress and yellow shoes.", "zh": "我姐姐穿着粉色连衣裙和黄色鞋子。", "keywords": ["pink", "yellow"]},
    {"en": "The old man has a gray beard. The young girl has red hair.", "zh": "老人有灰色的胡子。年轻女孩有红色的头发。", "keywords": ["old", "gray", "young", "red"]},
    {"en": "The orange sunset is beautiful. Everything looks cool.", "zh": "橙色的日落很美。一切看起来很酷。", "keywords": ["orange", "cool"]},
    {"en": "My dear friend, you look excellent today!", "zh": "亲爱的朋友，你今天看起来棒极了！", "keywords": ["dear", "excellent"]},
    {"en": "The furry cat is strange but cute. It has a double tail!", "zh": "毛茸茸的猫很奇怪但很可爱。它有两条尾巴！", "keywords": ["furry", "strange", "double"]},
    {"en": "I have several books. OK, let me count them.", "zh": "我有好几本书。好的，让我数数。", "keywords": ["several", "OK"]},
    {"en": "The door is closed. The room is quiet.", "zh": "门关着。房间很安静。", "keywords": ["closed"]}
])

add("The Guessing Game", "红3", ["Verbs – regular（规则动词）", "Verbs – irregular（不规则动词）", "Nouns（名词）"], [
    {"en": "Let us play a guessing game. Can you guess what I am thinking?", "zh": "我们来玩猜谜游戏。你能猜到我在想什么吗？", "keywords": ["guess"]},
    {"en": "I will act like an animal. You have to guess which one.", "zh": "我会表演一种动物。你必须猜是哪一种。", "keywords": ["act"]},
    {"en": "What happened? The lights went off! It was zero visibility.", "zh": "发生了什么？灯灭了！能见度为零。", "keywords": ["happen", "zero"]},
    {"en": "I prefer to play outside. I use my hands to make shapes.", "zh": "我更喜欢在外面玩。我用手做形状。", "keywords": ["prefer", "use"]},
    {"en": "I do my best every day. I am a good student.", "zh": "我每天都尽力。我是一个好学生。", "keywords": ["do", "be"]},
    {"en": "I lie on the grass and look at the clouds.", "zh": "我躺在草地上看云。", "keywords": ["lie"]},
    {"en": "I make a cake and take it to school.", "zh": "我做了一个蛋糕带到学校。", "keywords": ["make", "take"]},
    {"en": "I win the game! Everyone claps and cheers.", "zh": "我赢了游戏！每个人都鼓掌欢呼。", "keywords": ["win"]}
])

add("The Question Time", "红3", ["Question words（疑问词）", "Adverbs (Continued)（副词 续）"], [
    {"en": "How are you today? I am fine, thank you.", "zh": "你今天怎么样？我很好，谢谢。", "keywords": ["how"]},
    {"en": "How many books do you have? How old are you?", "zh": "你有多少本书？你多大了？", "keywords": ["how many", "how old"]},
    {"en": "What is your name? Where do you live?", "zh": "你叫什么名字？你住在哪里？", "keywords": ["what", "where"]},
    {"en": "Which colour do you like? Who is your best friend?", "zh": "你喜欢哪种颜色？谁是你最好的朋友？", "keywords": ["which", "who"]},
    {"en": "Whose bag is this? Pardon? I did not hear you.", "zh": "这是谁的包？什么？我没听到你说的。", "keywords": ["whose", "pardon"]},
    {"en": "Have you ever been to London? Of course I have!", "zh": "你去过伦敦吗？我当然去过！", "keywords": ["ever", "of course"]},
    {"en": "Can you do it by yourself? I can try!", "zh": "你能自己做吗？我可以试试！", "keywords": ["by yourself"]},
    {"en": "I like this book too. It is as good as the other one.", "zh": "我也喜欢这本书。它和另一本一样好。", "keywords": ["too", "as"]}
])

# Merge
articles_data['articles'].extend(new_articles)
articles_data['version'] = "2.0"

with open('flutter_app/assets/articles.json', 'w', encoding='utf-8') as f:
    json.dump(articles_data, f, ensure_ascii=False, indent=2)

print(f"Total articles: {len(articles_data['articles'])}")
print(f"New articles added: {len(new_articles)}")
