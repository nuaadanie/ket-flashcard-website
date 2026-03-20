#!/usr/bin/env python3
"""
Auto-generate reading articles covering ALL KET words.
Each topic group gets enough articles to cover every word.
Words per paragraph: ~3-4, paragraphs per article: ~8-10.
"""
import json, math

with open('flutter_app/assets/words.json', encoding='utf-8') as f:
    words_data = json.load(f)

all_words = words_data['words']

# Filter out non-word entries (numbers, names, etc.)
skip_topics = {'Names（人名）', 'Numbers（数字）'}

# Group by (level, topic)
by_lt = {}
for w in all_words:
    t = w.get('topic', '未分类')
    if t in skip_topics:
        continue
    key = (w['level'], t)
    by_lt.setdefault(key, []).append(w)

# Sentence templates: each takes (w1, w2, w3) or fewer
# Returns (en_template, zh_template) with {0},{1},{2} for word, {m0},{m1},{m2} for meaning
templates_3 = [
    ("I like {0}. My friend also likes {1} and {2}.",
     "我喜欢{m0}。我的朋友也喜欢{m1}和{m2}。"),
    ("Can you see the {0}? It is next to the {1} and the {2}.",
     "你能看到{m0}吗？它在{m1}和{m2}旁边。"),
    ("Today I learned about {0}, {1} and {2}. They are all very useful words.",
     "今天我学了{m0}、{m1}和{m2}。它们都是非常有用的词。"),
    ("The teacher told us about {0}. She also talked about {1} and {2}.",
     "老师给我们讲了{m0}。她还讲了{m1}和{m2}。"),
    ("In the morning, I saw {0}. In the afternoon, I found {1} and {2}.",
     "早上，我看到了{m0}。下午，我发现了{m1}和{m2}。"),
    ("My sister knows about {0} and {1}. I told her about {2} too.",
     "我姐姐知道{m0}和{m1}。我也告诉了她{m2}。"),
    ("We need {0} for the project. We also need {1} and {2}.",
     "我们的项目需要{m0}。我们还需要{m1}和{m2}。"),
    ("Have you heard of {0}? It is related to {1} and {2}.",
     "你听说过{m0}吗？它和{m1}以及{m2}有关。"),
    ("First, let me explain {0}. Then we will look at {1} and {2}.",
     "首先，让我解释一下{m0}。然后我们来看{m1}和{m2}。"),
    ("The book mentions {0}, {1} and {2}. I found it very interesting.",
     "这本书提到了{m0}、{m1}和{m2}。我觉得非常有趣。"),
]

templates_2 = [
    ("Do you know {0}? It is similar to {1}.",
     "你知道{m0}吗？它和{m1}类似。"),
    ("I often use {0} and {1} in my daily life.",
     "我在日常生活中经常用到{m0}和{m1}。"),
    ("The difference between {0} and {1} is important to understand.",
     "理解{m0}和{m1}之间的区别很重要。"),
    ("My dad explained {0} to me. He also told me about {1}.",
     "爸爸给我解释了{m0}。他还告诉了我{m1}。"),
]

templates_1 = [
    ("Remember the word {0}. It is very useful to know.",
     "记住{m0}这个词。知道它非常有用。"),
    ("The word {0} appears often in English. Try to use it!",
     "{m0}这个词在英语中经常出现。试着使用它吧！"),
    ("Don't forget about {0}. You will see it again soon.",
     "不要忘记{m0}。你很快会再次看到它。"),
]

# Topic-specific openers and closers
topic_intros = {
    "Animals": ("Let's explore the wonderful world of animals!", "让我们探索奇妙的动物世界！"),
    "Clothes": ("Getting dressed is part of our daily routine.", "穿衣打扮是我们日常生活的一部分。"),
    "Colours": ("The world is full of beautiful colours.", "世界充满了美丽的颜色。"),
    "Family": ("Family is the most important thing in life.", "家人是生活中最重要的。"),
    "Food": ("Food gives us energy and makes us happy.", "食物给我们能量，让我们快乐。"),
    "Health": ("Staying healthy is very important for everyone.", "保持健康对每个人都很重要。"),
    "IT": ("Technology is changing our lives every day.", "科技每天都在改变我们的生活。"),
    "Materials": ("Everything around us is made of different materials.", "我们周围的一切都由不同的材料制成。"),
    "Modals": ("Modal verbs help us express different meanings.", "情态动词帮助我们表达不同的含义。"),
    "Nouns": ("Nouns are words that name things around us.", "名词是给我们周围事物命名的词。"),
    "Places": ("There are many interesting places to visit.", "有很多有趣的地方可以参观。"),
    "Prepositions": ("Prepositions help us describe where things are.", "介词帮助我们描述事物的位置。"),
    "Pronouns": ("Pronouns replace nouns to make sentences shorter.", "代词替代名词使句子更简短。"),
    "Question": ("Asking questions is the best way to learn.", "提问是学习的最好方式。"),
    "Sports": ("Sports and hobbies make our life more fun.", "运动和爱好让我们的生活更有趣。"),
    "The body": ("Our body is amazing. Let's learn about it.", "我们的身体很神奇。让我们来了解它。"),
    "The home": ("Home is where we feel safe and comfortable.", "家是我们感到安全和舒适的地方。"),
    "Verbs": ("Verbs are action words. They tell us what happens.", "动词是动作词。它们告诉我们发生了什么。"),
    "Adjectives": ("Adjectives describe how things look and feel.", "形容词描述事物的外观和感觉。"),
    "Adverbs": ("Adverbs tell us how, when and where things happen.", "副词告诉我们事情如何、何时、在哪里发生。"),
    "Conjunctions": ("Conjunctions connect words and sentences together.", "连词把词和句子连接在一起。"),
    "Determiners": ("Determiners come before nouns to give more information.", "限定词放在名词前面提供更多信息。"),
    "Exclamations": ("Exclamations show our feelings and emotions.", "感叹语表达我们的感受和情绪。"),
}

def get_intro(topic):
    for key, val in topic_intros.items():
        if key.lower() in topic.lower():
            return val
    return ("Let's learn some new words today!", "今天让我们学习一些新词汇！")

def get_closer(topic):
    return ("Keep practising these words. You are doing great!", "继续练习这些词汇。你做得很棒！")

def build_paragraphs(word_list):
    """Build paragraphs from a list of words, 3 words per paragraph."""
    paras = []
    ti = 0  # template index
    
    i = 0
    while i < len(word_list):
        remaining = len(word_list) - i
        if remaining >= 3:
            batch = word_list[i:i+3]
            t_en, t_zh = templates_3[ti % len(templates_3)]
            ti += 1
            en = t_en.format(batch[0]['word'], batch[1]['word'], batch[2]['word'])
            zh = t_zh.format(m0=batch[0]['meaning'], m1=batch[1]['meaning'], m2=batch[2]['meaning'])
            paras.append((en, zh, [w['word'] for w in batch]))
            i += 3
        elif remaining == 2:
            batch = word_list[i:i+2]
            t_en, t_zh = templates_2[ti % len(templates_2)]
            ti += 1
            en = t_en.format(batch[0]['word'], batch[1]['word'])
            zh = t_zh.format(m0=batch[0]['meaning'], m1=batch[1]['meaning'])
            paras.append((en, zh, [w['word'] for w in batch]))
            i += 2
        else:
            batch = [word_list[i]]
            t_en, t_zh = templates_1[ti % len(templates_1)]
            ti += 1
            en = t_en.format(batch[0]['word'])
            zh = t_zh.format(m0=batch[0]['meaning'])
            paras.append((en, zh, [batch[0]['word']]))
            i += 1
    
    return paras

# Generate articles
articles = []
aid = 0

# Also keep the hand-crafted articles from v1
with open('flutter_app/assets/articles.json', encoding='utf-8') as f:
    existing = json.load(f)
    articles = existing['articles']
    aid = max(a['id'] for a in articles)

# Track which words are already covered
covered = {}  # level -> set of word strings
for a in articles:
    lv = a['level']
    covered.setdefault(lv, set())
    for p in a['paragraphs']:
        for kw in p.get('keywords', []):
            covered[lv].add(kw.lower())

# Generate new articles for uncovered words
for (level, topic), word_list in sorted(by_lt.items()):
    # Find uncovered words in this group
    cov = covered.get(level, set())
    uncovered = [w for w in word_list if w['word'].lower() not in cov]
    
    if not uncovered:
        continue
    
    # Split into articles of ~8-10 paragraphs (24-30 words each)
    words_per_article = 24
    num_articles = math.ceil(len(uncovered) / words_per_article)
    
    for part in range(num_articles):
        start = part * words_per_article
        end = min(start + words_per_article, len(uncovered))
        batch = uncovered[start:end]
        
        if not batch:
            continue
        
        aid += 1
        
        # Build title
        short_topic = topic.split('（')[0].strip()
        if num_articles > 1:
            title = f"{short_topic} ({part+1})"
        else:
            title = short_topic
        
        # Build paragraphs
        intro_en, intro_zh = get_intro(topic)
        closer_en, closer_zh = get_closer(topic)
        
        paras = [(intro_en, intro_zh, [])]
        paras.extend(build_paragraphs(batch))
        paras.append((closer_en, closer_zh, []))
        
        articles.append({
            "id": aid,
            "title": title,
            "level": level,
            "topics": [topic],
            "paragraphs": [{"en": p[0], "zh": p[1], "keywords": p[2]} for p in paras]
        })

# Write output
output = {"version": "2.0", "articles": articles}
with open("flutter_app/assets/articles.json", "w", encoding="utf-8") as f:
    json.dump(output, f, ensure_ascii=False, indent=2)

# Stats
print(f"Total articles: {len(articles)}")
for lv in ["黑1", "蓝2", "红3"]:
    count = len([a for a in articles if a["level"] == lv])
    print(f"  {lv}: {count} articles")

# Coverage check
covered2 = {}
for a in articles:
    lv = a['level']
    covered2.setdefault(lv, set())
    for p in a['paragraphs']:
        for kw in p.get('keywords', []):
            covered2[lv].add(kw.lower())

words_by_level = {}
for w in all_words:
    if w.get('topic','') in skip_topics:
        continue
    lv = w['level']
    words_by_level.setdefault(lv, set()).add(w['word'].lower())

print("\nCoverage:")
for lv in ["黑1", "蓝2", "红3"]:
    total = len(words_by_level.get(lv, set()))
    cov = len(covered2.get(lv, set()))
    pct = cov / total * 100 if total > 0 else 0
    print(f"  {lv}: {cov}/{total} ({pct:.0f}%)")
