#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
解析KET单词文档，生成words.json
"""

import json
import re
from docx import Document
from pathlib import Path

def parse_docx():
    """解析Word文档"""
    doc_path = '/home/admin/.openclaw/workspace-codingagent/projects/剑桥1-3单词.docx'
    doc = Document(doc_path)
    
    words = []
    current_topic = None
    word_id = 1
    
    # 颜色到级别的映射
    color_to_level = {
        None: '黑1',           # 默认颜色 - 黑1
        '0000FF': '蓝2',       # 蓝色 - 蓝2
        '0070C0': '蓝2',       # 另一种蓝色 - 蓝2
        '4874CB': '蓝2',       # 第三种蓝色 - 蓝2
        'C00000': '红3',       # 红色 - 红3
    }
    
    for para in doc.paragraphs:
        text = para.text.strip()
        
        # 跳过空行和级别说明行
        if not text:
            continue
        if text == '黑1  蓝2  红3':
            continue
        
        # 判断是否是主题标题（粗体）
        is_topic = False
        if para.runs and para.runs[0].bold:
            # 检查是否是主题格式："XXX（YYY）"
            if '（' in text and '）' in text:
                current_topic = text
                print(f"发现主题: {current_topic}")
                continue
        
        # 解析单词列表
        if current_topic:
            # 按"，"分割单词
            word_items = re.split(r'[，,]', text)
            
            for item in word_items:
                item = item.strip()
                if not item:
                    continue
                
                # 分离单词和释义
                # 格式："word 释义" 或 "word (note) 释义"
                match = re.match(r'^(\S+(?:\s+\S+)*?)\s+(.+)$', item)
                if match:
                    word = match.group(1).strip()
                    meaning = match.group(2).strip()
                    
                    # 确定级别（根据第一个有颜色的run）
                    level = '黑1'  # 默认级别
                    for run in para.runs:
                        if run.text.strip() and word in run.text:
                            if run.font.color and run.font.color.rgb:
                                color_str = str(run.font.color.rgb)
                                level = color_to_level.get(color_str, '黑1')
                            break
                    
                    # 简单的音节划分（后续可以优化）
                    syllables = split_syllables(word)
                    
                    word_data = {
                        'id': word_id,
                        'word': word,
                        'phonetic': generate_phonetic(word),  # 生成音标（简化版）
                        'meaning': meaning,
                        'level': level,
                        'topic': current_topic,
                        'syllables': syllables
                    }
                    words.append(word_data)
                    word_id += 1
                else:
                    print(f"警告：无法解析单词项: {item}")
    
    return words

def split_syllables(word):
    """简单的音节划分"""
    # 这是一个简化版本，实际可以使用更复杂的库
    vowels = 'aeiouAEIOU'
    syllables = []
    current = ''
    
    for i, char in enumerate(word):
        current += char
        if char in vowels and i < len(word) - 1:
            if word[i+1] not in vowels:
                syllables.append(current)
                current = ''
    
    if current:
        syllables.append(current)
    
    # 如果没有划分成功，返回整个单词
    if not syllables or len(syllables) == 1:
        return [word]
    
    return syllables

def generate_phonetic(word):
    """生成简化的音标（占位符，后续可以使用真实的音标库）"""
    # 这里使用简化的占位符，实际项目中可以使用专门的音标库
    # 如：eng_to_ipa 等
    return f"/{word.lower()}/"

def main():
    """主函数"""
    print("开始解析Word文档...")
    
    # 解析文档
    words = parse_docx()
    
    print(f"\n解析完成！共提取 {len(words)} 个单词")
    
    # 统计各级别和主题的单词数量
    level_count = {}
    topic_count = {}
    
    for word in words:
        level = word['level']
        topic = word['topic']
        level_count[level] = level_count.get(level, 0) + 1
        topic_count[topic] = topic_count.get(topic, 0) + 1
    
    print("\n各级别单词数量:")
    for level, count in sorted(level_count.items()):
        print(f"  {level}: {count}")
    
    print("\n各主题单词数量:")
    for topic, count in sorted(topic_count.items()):
        print(f"  {topic}: {count}")
    
    # 创建data目录
    data_dir = Path('/home/admin/.openclaw/workspace-codingagent/projects/ket-flashcard-website/data')
    data_dir.mkdir(exist_ok=True)
    
    # 保存为JSON
    output_path = data_dir / 'words.json'
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump({
            'version': '1.0',
            'total': len(words),
            'levels': sorted(list(level_count.keys())),
            'topics': sorted(list(topic_count.keys())),
            'words': words
        }, f, ensure_ascii=False, indent=2)
    
    print(f"\n数据已保存到: {output_path}")
    
    # 显示前几个单词作为示例
    print("\n前5个单词示例:")
    for word in words[:5]:
        print(f"  {word['word']} - {word['meaning']} ({word['level']}, {word['topic']})")

if __name__ == '__main__':
    main()
