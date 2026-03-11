#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
验证生成的JSON文件
"""

import json

with open('/home/admin/.openclaw/workspace-codingagent/projects/ket-flashcard-website/data/words.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

print("✅ JSON文件验证成功！")
print(f"版本: {data['version']}")
print(f"总单词数: {data['total']}")
print(f"级别: {data['levels']}")
print(f"主题数: {len(data['topics'])}")
print(f"\n前5个单词:")
for word in data['words'][:5]:
    print(f"  {word['id']}. {word['word']} - {word['meaning']} ({word['level']})")
