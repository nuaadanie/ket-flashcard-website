#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
解析KET单词文档，生成words.json - 优化版
更准确地判断每个单词的颜色级别
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
    
    for para_idx, para in enumerate(doc.paragraphs):
        text = para.text.strip()
        
        # 跳过空行和级别说明行
        if not text:
            continue
        if text == '黑1  蓝2  红3':
            continue
        
        # 判断是否是主题标题（粗体）
        is_topic = False
        if para.runs and para.runs[0].bold:
            # 检查是否是主题格式："XXX（YYY）" 或类似标题
            if '（' in text and '）' in text:
                current_topic = text
                print(f"发现主题: {current_topic}")
                continue
            # 其他可能的主题格式
            if text in ['School（学校）', 'Time（时间）', 'Toys（玩具）', 
                       'Transport（交通）', 'Weather（天气）', 'Work（工作与职业）']:
                current_topic = text
                print(f"发现主题: {current_topic}")
                continue
        
        # 解析单词列表
        if current_topic:
            # 先收集所有run的信息
            run_info = []
            for run in para.runs:
                if run.text.strip():
                    color = None
                    if run.font.color and run.font.color.rgb:
                        color = str(run.font.color.rgb)
                    run_info.append({
                        'text': run.text,
                        'color': color,
                        'bold': run.bold
                    })
            
            # 按"，"分割整个段落文本
            word_items = re.split(r'[，,]', text)
            
            # 追踪当前处理到的位置
            current_pos = 0
            
            for item in word_items:
                item = item.strip()
                if not item:
                    continue
                
                # 分离单词和释义
                match = re.match(r'^(\S+(?:\s+\S+)*?)\s+(.+)$', item)
                if match:
                    word = match.group(1).strip()
                    meaning = match.group(2).strip()
                    
                    # 确定级别：找到包含这个单词的run的颜色
                    level = '黑1'  # 默认级别
                    for run in run_info:
                        if word in run['text']:
                            if run['color']:
                                # 根据颜色判断级别
                                if run['color'] in ['0000FF', '0070C0', '4874CB']:
                                    level = '蓝2'
                                elif run['color'] == 'C00000':
                                    level = '红3'
                            break
                    
                    # 简单的音节划分
                    syllables = split_syllables(word)
                    
                    word_data = {
                        'id': word_id,
                        'word': word,
                        'phonetic': generate_phonetic(word),
                        'meaning': meaning,
                        'level': level,
                        'topic': current_topic,
                        'syllables': syllables
                    }
                    words.append(word_data)
                    word_id += 1
                else:
                    # 尝试处理一些特殊情况
                    if re.match(r'^\d+', item):  # 跳过数字开头的
                        continue
                    print(f"警告：无法解析单词项: {item}")
    
    return words

def split_syllables(word):
    """简单的音节划分"""
    vowels = 'aeiouAEIOU'
    result = []
    current = ''
    
    # 简化版本，实际项目可用更专业的库
    return [word]

def generate_phonetic(word):
    """生成简化的音标"""
    # 这里使用简化的占位符
    return f"/{word.lower()}/"

def main():
    """主函数"""
    print("开始解析Word文档（优化版）...")
    
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
    for level in ['黑1', '蓝2', '红3']:
        count = level_count.get(level, 0)
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
            'levels': ['黑1', '蓝2', '红3'],
            'topics': sorted(list(topic_count.keys())),
            'words': words
        }, f, ensure_ascii=False, indent=2)
    
    print(f"\n数据已保存到: {output_path}")
    
    # 显示各级别的一些示例
    print("\n各级别单词示例:")
    for level in ['黑1', '蓝2', '红3']:
        level_words = [w for w in words if w['level'] == level][:3]
        print(f"\n  {level}:")
        for w in level_words:
            print(f"    {w['word']} - {w['meaning']}")

if __name__ == '__main__':
    main()
