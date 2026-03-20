#!/usr/bin/env python3
"""Second pass: add remaining IPA phonetics for words missed in first pass."""

import json
import re

EXTRA_IPA = {
    # Family & friends
    "kids": "kɪdz", "grown-up": "ˈɡrəʊn ʌp", "married": "ˈmærid",
    "surname": "ˈsɜːneɪm",
    # Food & drink
    "chips": "tʃɪps", "kiwi": "ˈkiːwi", "lime": "laɪm",
    "meatballs": "ˈmiːtbɔːlz", "sweet(s)": "swiːt(s)",
    "milkshake": "ˈmɪlkʃeɪk", "noodles": "ˈnuːdlz",
    "pancake": "ˈpænkeɪk", "butter": "ˈbʌtə(r)",
    "chopsticks": "ˈtʃɒpstɪks", "olives": "ˈɒlɪvz", "piece": "piːs",
    # Health
    "stomach-ache": "ˈstʌmək eɪk", "chemist('s)": "ˈkemɪst(s)",
    # Home
    "armchair": "ˈɑːmtʃeə(r)", "address": "əˈdres",
    "basement": "ˈbeɪsmənt", "comb": "kəʊm", "cooker": "ˈkʊkə(r)",
    "cushion": "ˈkʊʃn", "diary": "ˈdaɪəri", "envelope": "ˈenvələʊp",
    "doll": "dɒl", "mat": "mæt", "painting": "ˈpeɪntɪŋ", "rug": "rʌɡ",
    "toothbrush": "ˈtuːθbrʌʃ", "toothpaste": "ˈtuːθpeɪst",
    "oven": "ˈʌvn", "shampoo": "ʃæmˈpuː", "soap": "səʊp",
    "stamp": "stæmp", "swing": "swɪŋ", "telephone": "ˈtelɪfəʊn",
    # IT
    "e-book": "ˈiːbʊk", "programme": "ˈprəʊɡræm", "wifi": "ˈwaɪfaɪ",
    "card": "kɑːd",
    # Names
    "Alex": "ˈælɪks", "Alice": "ˈælɪs", "Anna": "ˈænə",
    "Ben": "ben", "Bill": "bɪl", "Dan": "dæn", "Eva": "ˈiːvə",
    "Grace": "ɡreɪs", "Hugo": "ˈhjuːɡəʊ", "Jill": "dʒɪl",
    "Kim": "kɪm", "Lucy": "ˈluːsi", "Matt": "mæt", "Nick": "nɪk",
    "Pat": "pæt", "Sam": "sæm", "Sue": "suː", "Tom": "tɒm",
    "Charlie": "ˈtʃɑːli", "Clare": "kleə(r)", "Daisy": "ˈdeɪzi",
    "Fred": "fred", "Jack": "dʒæk", "Jane": "dʒeɪn", "Jim": "dʒɪm",
    "Julia": "ˈdʒuːliə", "Lily": "ˈlɪli", "Mary": "ˈmeəri",
    "Paul": "pɔːl", "Peter": "ˈpiːtə(r)", "Sally": "ˈsæli",
    "Vicky": "ˈvɪki", "Zoe": "ˈzəʊi", "Betty": "ˈbeti",
    "David": "ˈdeɪvɪd", "Emma": "ˈemə", "Frank": "fræŋk",
    "George": "dʒɔːdʒ", "Harry": "ˈhæri", "Helen": "ˈhelən",
    "Holly": "ˈhɒli", "Katy": "ˈkeɪti", "Michael": "ˈmaɪkl",
    "Oliver": "ˈɒlɪvə(r)", "Richard": "ˈrɪtʃəd", "Robert": "ˈrɒbət",
    "Sarah": "ˈseərə", "Sophia": "səˈfɪə", "William": "ˈwɪljəm",
}

EXTRA_IPA.update({
    # Numbers (special entries)
    "1-20": "", "21-100": "", "1st": "", "000": "", "21st": "",
    # Places
    "building": "ˈbɪldɪŋ", "circle": "ˈsɜːkl", "funfair": "ˈfʌnfeə(r)",
    "square": "skweə(r)", "college": "ˈkɒlɪdʒ", "front": "frʌnt",
    "kilometre": "ˈkɪləmiːtə(r)", "London": "ˈlʌndən",
    "middle": "ˈmɪdl", "skyscraper": "ˈskaɪskreɪpə(r)",
    # School
    "alphabet": "ˈælfəbet", "crayons": "ˈkreɪənz",
    "English": "ˈɪŋɡlɪʃ", "poster": "ˈpəʊstə(r)",
    "mistake": "mɪˈsteɪk", "art": "ɑːt", "backpack": "ˈbækpæk",
    "flag": "flæɡ", "group": "ɡruːp", "rucksack": "ˈrʌksæk",
    "scissors": "ˈsɪzəz", "timetable": "ˈtaɪmteɪbl",
})

EXTRA_IPA.update({
    # Sports & leisure
    "bounce": "baʊns", "drawing": "ˈdrɔːɪŋ",
    "CD": "ˌsiːˈdiː", "DVD": "ˌdiːviːˈdiː", "film": "fɪlm",
    "hop": "hɒp", "president": "ˈprezɪdənt", "sail": "seɪl",
    "skip": "skɪp", "cartoon": "kɑːˈtuːn", "channel": "ˈtʃænl",
    "flashlight": "ˈflæʃlaɪt", "invitation": "ˌɪnvɪˈteɪʃn",
    "magazine": "ˌmæɡəˈziːn", "quiz": "kwɪz",
    "sledge": "sledʒ", "snowball": "ˈsnəʊbɔːl",
    "snowboard": "ˈsnəʊbɔːd", "snowboarding": "ˈsnəʊbɔːdɪŋ",
    "skateboarding": "ˈskeɪtbɔːdɪŋ", "snowman": "ˈsnəʊmæn",
    "tent": "tent", "torch": "tɔːtʃ", "tune": "tjuːn",
    "winner": "ˈwɪnə(r)", "o'clock": "əˈklɒk",
    # Time
    "a.m.": "ˌeɪˈem", "autumn": "ˈɔːtəm", "calendar": "ˈkælɪndə(r)",
    "century": "ˈsentʃəri", "date": "deɪt", "early": "ˈɜːli",
    "future": "ˈfjuːtʃə(r)", "later": "ˈleɪtə(r)",
    "midday": "ˌmɪdˈdeɪ", "midnight": "ˈmɪdnaɪt",
    "month": "mʌnθ", "p.m.": "ˌpiːˈem",
    "spring": "sprɪŋ", "summer": "ˈsʌmə(r)", "winter": "ˈwɪntə(r)",
    # Toys & things
    "alien": "ˈeɪliən", "balloon": "bəˈluːn", "monster": "ˈmɒnstə(r)",
    "teddy": "ˈtedi", "model": "ˈmɒdl",
    # Transport
    "Transport": "", "tractor": "ˈtræktə(r)", "racing": "ˈreɪsɪŋ",
    "rocket": "ˈrɒkɪt", "spaceship": "ˈspeɪsʃɪp",
    "tour": "tʊə(r)",
    # Weather & nature
    "rainbow": "ˈreɪnbəʊ", "sky": "skaɪ", "pirate": "ˈpaɪrət",
    # Jobs
    "astronaut": "ˈæstrənɔːt", "business": "ˈbɪznəs",
    "designer": "dɪˈzaɪnə(r)", "meeting": "ˈmiːtɪŋ",
    "newspaper": "ˈnjuːzpeɪpə(r)", "office": "ˈɒfɪs",
})

EXTRA_IPA.update({
    # Nature & world
    "sand": "sænd", "shell": "ʃel", "countryside": "ˈkʌntrisaɪd",
    "grass": "ɡrɑːs", "ground": "ɡraʊnd", "leaf/leaves": "liːf/liːvz",
    "moon": "muːn", "plant": "plɑːnt", "wave": "weɪv",
    "air": "eə(r)", "Earth": "ɜːθ", "environment": "ɪnˈvaɪrənmənt",
    "planet": "ˈplænɪt", "pond": "pɒnd", "space": "speɪs",
    "stream": "striːm", "view": "vjuː",
    # Nouns
    "bottom": "ˈbɒtəm", "difference": "ˈdɪfrəns",
    "machine": "məˈʃiːn", "noise": "nɔɪz", "shape": "ʃeɪp",
    "treasure": "ˈtreʒə(r)", "bit": "bɪt",
    "conversation": "ˌkɒnvəˈseɪʃn", "engine": "ˈendʒɪn",
    "hole": "həʊl", "information": "ˌɪnfəˈmeɪʃn",
    "postcard": "ˈpəʊstkɑːd", "secret": "ˈsiːkrət",
    "sound": "saʊnd",
    # Verbs
    "clap": "klæp", "act": "ækt", "camp": "kæmp",
    "chat": "tʃæt", "cycle": "ˈsaɪkl", "explore": "ɪkˈsplɔː(r)",
    "fetch": "fetʃ", "whisper": "ˈwɪspə(r)", "whistle": "ˈwɪsl",
    "let's": "lets", "feed": "fiːd", "burn": "bɜːn",
    # Exclamations
    "Hooray!": "hʊˈreɪ", "Amazing!": "əˈmeɪzɪŋ",
    "Excellent!": "ˈeksələnt",
    # Adjectives
    "closed": "kləʊzd", "scary": "ˈskeəri",
    "frightened": "ˈfraɪtnd", "naughty": "ˈnɔːti",
    "quick": "kwɪk", "alone": "əˈləʊn", "amazing": "əˈmeɪzɪŋ",
    "bored": "bɔːd", "excellent": "ˈeksələnt", "far": "fɑː(r)",
    "frightening": "ˈfraɪtnɪŋ", "furry": "ˈfɜːri",
    "interested": "ˈɪntrəstɪd", "lazy": "ˈleɪzi",
    "missing": "ˈmɪsɪŋ", "pleased": "pliːzd", "sore": "sɔː(r)",
    "unfriendly": "ʌnˈfrendli", "unhappy": "ʌnˈhæpi",
    "unkind": "ʌnˈkaɪnd", "untidy": "ʌnˈtaɪdi",
    # Adverbs
    "badly": "ˈbædli", "carefully": "ˈkeəfəli",
    "actually": "ˈæktʃuəli", "anywhere": "ˈeniweə(r)",
    "as": "æz", "loudly": "ˈlaʊdli", "quickly": "ˈkwɪkli",
    "quietly": "ˈkwaɪətli", "else": "els",
    "everywhere": "ˈevriweə(r)", "nowhere": "ˈnəʊweə(r)",
    "somewhere": "ˈsʌmweə(r)",
    # Determiners & misc
    "such": "sʌtʃ", "no-one": "ˈnəʊ wʌn", "pardon": "ˈpɑːdn",
    # Special entries that are category headers or number ranges
    "Days of the week": "", "Months of the year": "",
    "The world around us": "", "(adv": "",
    "etc)": "",
}
)


def fix_extra():
    with open('data/words.json', 'r', encoding='utf-8') as f:
        data = json.load(f)

    fixed = 0
    still_missing = []

    for w in data['words']:
        p = w['phonetic'].strip('/')
        word = w['word']
        word_lower = word.lower()

        # Check if phonetic is still just the word itself (fake)
        if p == word_lower or p == word:
            # Try exact match
            if word in EXTRA_IPA:
                ipa = EXTRA_IPA[word]
                if ipa:
                    w['phonetic'] = f"/{ipa}/"
                    fixed += 1
                else:
                    w['phonetic'] = ""  # category headers
                    fixed += 1
            elif word_lower in EXTRA_IPA:
                ipa = EXTRA_IPA[word_lower]
                if ipa:
                    w['phonetic'] = f"/{ipa}/"
                    fixed += 1
                else:
                    w['phonetic'] = ""
                    fixed += 1
            else:
                # Check if it's a "simple" word where IPA = spelling
                simple = {'pet','nest','belt','red','bed','left','west',
                    'end','net','step','help','send','let','spend','best',
                    'wet','desk','pen','bit','tent'}
                if word_lower not in simple:
                    still_missing.append((w['id'], word, w['topic']))

    with open('data/words.json', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print(f"Extra pass fixed: {fixed}")
    if still_missing:
        print(f"Still missing: {len(still_missing)}")
        for wid, word, topic in still_missing:
            print(f"  {wid}: \"{word}\"")


if __name__ == '__main__':
    fix_extra()
