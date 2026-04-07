#!/usr/bin/env python3
"""
Convert Journey to the West formatted markdown files into xyj.json
for the Flutter reading feature.

Handles two formats:
- ep01~ep68: English + Chinese in same _formatted.md, separated by ---
- ep69~ep108: English in _formatted.md, Chinese in _chinese.md
"""

import json
import re
import os
import glob

FORMATTED_DIR = os.path.join(os.path.dirname(__file__), '..', 'assets', 'formatted')
WORDS_FILE = os.path.join(os.path.dirname(__file__), '..', 'assets', 'words.json')
OUTPUT_FILE = os.path.join(os.path.dirname(__file__), '..', 'assets', 'xyj.json')

# Circled number pattern: ①②③...⑩⑪⑫...
SECTION_RE = re.compile(r'^##\s+[①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳㉑㉒㉓㉔㉕㉖㉗㉘㉙㉚㉛㉜㉝㉞㉟㊱㊲㊳㊴㊵㊶㊷㊸㊹㊺㊻㊼㊽㊾㊿]')
TITLE_RE = re.compile(r'^#\s+Journey to the West\s*[·:：]\s*(.+)', re.IGNORECASE)
TITLE_ZH_RE = re.compile(r'^#\s+🇨🇳\s*(.+)')

# Common function words to exclude from keywords - these add no learning value
STOP_WORDS = {
    # articles & determiners
    'a', 'an', 'the', 'this', 'that', 'these', 'those', 'my', 'your', 'his',
    'her', 'its', 'our', 'their', 'some', 'any', 'no', 'every', 'each',
    'all', 'both', 'few', 'more', 'most', 'other', 'another', 'such',
    # pronouns
    'i', 'me', 'you', 'he', 'him', 'she', 'we', 'us', 'they', 'them',
    'it', 'who', 'whom', 'what', 'which', 'myself', 'yourself', 'himself',
    'herself', 'itself', 'ourselves', 'themselves',
    # prepositions
    'in', 'on', 'at', 'to', 'for', 'of', 'with', 'by', 'from', 'up',
    'about', 'into', 'through', 'during', 'before', 'after', 'above',
    'below', 'between', 'under', 'over', 'out', 'off', 'down', 'near',
    'against', 'along', 'around', 'behind', 'beside', 'beyond',
    # conjunctions
    'and', 'but', 'or', 'nor', 'so', 'yet', 'if', 'when', 'while',
    'because', 'although', 'though', 'as', 'than', 'that', 'whether',
    'until', 'since', 'unless',
    # auxiliary / modal verbs
    'is', 'am', 'are', 'was', 'were', 'be', 'been', 'being',
    'have', 'has', 'had', 'having',
    'do', 'does', 'did',
    'will', 'would', 'shall', 'should', 'may', 'might', 'can', 'could',
    'must', 'need',
    # very common verbs
    'go', 'get', 'got', 'make', 'made', 'say', 'said', 'see', 'saw',
    'come', 'came', 'take', 'took', 'know', 'knew', 'think', 'thought',
    'give', 'gave', 'tell', 'told', 'put', 'let',
    # adverbs & misc
    'not', 'very', 'also', 'just', 'only', 'then', 'now', 'here', 'there',
    'too', 'well', 'back', 'still', 'even', 'how', 'why', 'where',
    'much', 'many', 'own', 'same',
}


def load_ket_words():
    """Load KET word set from words.json."""
    with open(WORDS_FILE, 'r', encoding='utf-8') as f:
        data = json.load(f)
    return set(w['word'].lower() for w in data['words'])


def parse_sections(text):
    """Parse markdown text into numbered sections.
    Returns list of (section_number_str, content_lines).
    """
    sections = []
    current_lines = None

    for line in text.split('\n'):
        if SECTION_RE.match(line.strip()):
            if current_lines is not None:
                sections.append(current_lines)
            current_lines = []
        elif current_lines is not None:
            current_lines.append(line)

    if current_lines is not None:
        sections.append(current_lines)

    return sections


def lines_to_text(lines):
    """Merge lines into a single paragraph text.
    Strips markdown quote markers (> ) and joins non-empty lines.
    """
    result = []
    for line in lines:
        stripped = line.strip()
        if not stripped:
            continue
        # Remove markdown quote prefix
        if stripped.startswith('> '):
            stripped = stripped[2:]
        elif stripped.startswith('>'):
            stripped = stripped[1:].strip()
        result.append(stripped)
    return ' '.join(result)


def extract_keywords(en_text, ket_words):
    """Find KET words that appear in the English text, excluding stop words."""
    # Extract all words from text
    words_in_text = set(re.findall(r"[a-zA-Z']+", en_text.lower()))
    # Also check base forms by stripping common suffixes
    found = set()
    for w in words_in_text:
        if w in STOP_WORDS:
            continue
        if w in ket_words:
            found.add(w)
            continue
        # Check without trailing 's', 'ed', 'ing', 'er', 'est', 'ly'
        for suffix in ['s', 'es', 'ed', 'ing', 'er', 'est', 'ly', 'ies', 'ied']:
            base = w[:-len(suffix)]
            if base and w.endswith(suffix) and base in ket_words and base not in STOP_WORDS:
                found.add(base)
                break
    return sorted(found)


def parse_episode_combined(filepath):
    """Parse ep01~ep68 style: English and Chinese in same file, separated by ---."""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Split by --- separator
    parts = re.split(r'\n---\n', content, maxsplit=1)
    en_part = parts[0]
    zh_part = parts[1] if len(parts) > 1 else ''

    # Extract title
    title_en = ''
    for line in en_part.split('\n'):
        m = TITLE_RE.match(line.strip())
        if m:
            title_en = m.group(1).strip()
            break

    title_zh = ''
    for line in zh_part.split('\n'):
        m = TITLE_ZH_RE.match(line.strip())
        if m:
            title_zh = m.group(1).strip()
            break

    en_sections = parse_sections(en_part)
    zh_sections = parse_sections(zh_part)

    return title_en, title_zh, en_sections, zh_sections


def parse_episode_separate(formatted_path, chinese_path):
    """Parse ep69~ep108 style: English and Chinese in separate files."""
    with open(formatted_path, 'r', encoding='utf-8') as f:
        en_content = f.read()

    zh_content = ''
    if os.path.exists(chinese_path):
        with open(chinese_path, 'r', encoding='utf-8') as f:
            zh_content = f.read()

    # Check if formatted file also has Chinese section (some might)
    if '---' in en_content:
        parts = re.split(r'\n---\n', en_content, maxsplit=1)
        en_content = parts[0]
        # If the second part has Chinese, use it
        if len(parts) > 1 and TITLE_ZH_RE.search(parts[1]):
            zh_content = parts[1]

    title_en = ''
    for line in en_content.split('\n'):
        m = TITLE_RE.match(line.strip())
        if m:
            title_en = m.group(1).strip()
            break

    title_zh = ''
    for line in zh_content.split('\n'):
        m = TITLE_ZH_RE.match(line.strip())
        if m:
            title_zh = m.group(1).strip()
            break

    en_sections = parse_sections(en_content)
    zh_sections = parse_sections(zh_content)

    return title_en, title_zh, en_sections, zh_sections


def main():
    ket_words = load_ket_words()
    print(f"Loaded {len(ket_words)} KET words")

    chapters = []

    for ep_num in range(1, 109):
        # Try different filename patterns
        formatted_path = None
        for pattern in [f'ep{ep_num:02d}_formatted.md', f'ep{ep_num}_formatted.md']:
            p = os.path.join(FORMATTED_DIR, pattern)
            if os.path.exists(p):
                formatted_path = p
                break

        if not formatted_path:
            print(f"  WARNING: ep{ep_num} formatted.md not found, skipping")
            continue

        chinese_path = None
        for pattern in [f'ep{ep_num:02d}_chinese.md', f'ep{ep_num}_chinese.md']:
            p = os.path.join(FORMATTED_DIR, pattern)
            if os.path.exists(p):
                chinese_path = p
                break

        # Parse based on whether separate chinese file exists
        if chinese_path:
            title_en, title_zh, en_sections, zh_sections = parse_episode_separate(
                formatted_path, chinese_path)
        else:
            title_en, title_zh, en_sections, zh_sections = parse_episode_combined(
                formatted_path)

        # Build paragraphs
        paragraphs = []
        for i, en_lines in enumerate(en_sections):
            en_text = lines_to_text(en_lines)
            if not en_text.strip():
                continue

            zh_text = ''
            if i < len(zh_sections):
                zh_text = lines_to_text(zh_sections[i])

            keywords = extract_keywords(en_text, ket_words)

            paragraphs.append({
                'en': en_text,
                'zh': zh_text,
                'keywords': keywords,
            })

        if not title_en:
            title_en = f'Chapter {ep_num}'

        chapter = {
            'id': 10000 + ep_num,  # Offset to avoid collision with article IDs
            'title': title_en,
            'titleZh': title_zh,
            'level': '西游记',
            'topics': ['西游记'],
            'paragraphs': paragraphs,
        }
        chapters.append(chapter)
        print(f"  ep{ep_num:03d}: {title_en} | {len(paragraphs)} paragraphs | {sum(len(p['keywords']) for p in paragraphs)} KET words")

    output = {
        'version': '1.0',
        'chapters': chapters,
    }

    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        json.dump(output, f, ensure_ascii=False, indent=2)

    print(f"\nDone! {len(chapters)} chapters written to {OUTPUT_FILE}")


if __name__ == '__main__':
    main()
