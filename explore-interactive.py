#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
import time
import os

def main():
    # 配置 Chrome 选项
    chrome_options = Options()
    chrome_options.add_argument('--headless')
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    chrome_options.add_argument('--disable-gpu')
    chrome_options.add_argument('--window-size=1920,1080')

    # 启动 Chrome 浏览器
    driver = webdriver.Chrome(options=chrome_options)
    driver.set_page_load_timeout(60)

    try:
        # 导航到服务器上的 standalone.html 文件
        url = 'http://localhost:9000/standalone.html'
        driver.get(url)
        print('✅ 页面加载成功')

        # 等待页面加载
        time.sleep(2)

        # 检查页面标题
        print('页面标题:', driver.title)

        # 检查页面的 HTML 结构
        page_source = driver.page_source
        print('页面标题标签内容:', driver.find_element(By.TAG_NAME, 'title').text)

        # 检查模式切换按钮是否存在
        mode_buttons = driver.find_elements(By.CLASS_NAME, 'mode-btn')
        print(f'找到 {len(mode_buttons)} 个模式切换按钮')
        for i, btn in enumerate(mode_buttons):
            print(f'按钮 {i+1}: 文本 = "{btn.text.strip()}", data-mode = "{btn.get_attribute("data-mode")}"')

        # 模拟用户点击"按主题学习"按钮
        topic_mode_btn = None
        for btn in mode_buttons:
            if btn.get_attribute('data-mode') == 'topic':
                topic_mode_btn = btn
                break

        if topic_mode_btn:
            topic_mode_btn.click()
            print('✅ 点击"按主题学习"按钮')
            time.sleep(1)

            # 检查主题选择器是否可见
            topic_selector = driver.find_element(By.ID, 'topic-selector')
            print(f'主题选择器可见: {topic_selector.is_displayed()}')

            # 检查主题选择器是否可见
            if topic_selector.is_displayed():
                print('✅ 主题选择器可见')
            else:
                print('❌ 主题选择器不可见')

            # 模拟用户选择一个主题
            topic_dropdown = driver.find_element(By.ID, 'topic-dropdown')
            print('主题选择器的选项数量:', len(topic_dropdown.find_elements(By.TAG_NAME, 'option')))

            # 选择主题
            for option in topic_dropdown.find_elements(By.TAG_NAME, 'option'):
                if 'Animals' in option.text or '动物' in option.text:
                    print(f'选择主题: {option.text.strip()}')
                    option.click()
                    break
            else:
                print('❌ 未找到包含"Animals"或"动物"的主题')

            # 等待单词变化
            time.sleep(3)

            # 获取当前显示的单词
            word = driver.find_element(By.ID, 'word').text.strip()
            meaning = driver.find_element(By.ID, 'meaning').text.strip()
            topic_tag = driver.find_element(By.ID, 'topic-tag').text.strip()

            print(f'✅ 当前显示的单词: {word}')
            print(f'✅ 当前显示的含义: {meaning}')
            print(f'✅ 当前显示的主题: {topic_tag}')

            # 验证单词是否属于所选主题
            if 'Animals' in topic_tag or '动物' in topic_tag:
                print('✅ 单词主题验证成功')
            else:
                print(f'❌ 单词主题验证失败，预期: 包含"Animals"或"动物"，实际: {topic_tag}')

            # 验证单词是否变化
            if word:
                print('✅ 单词显示验证成功')
            else:
                print('❌ 单词显示验证失败')

        else:
            print('❌ 未找到"按主题学习"按钮')

    except Exception as e:
        print(f'❌ 测试过程中出现错误: {e}')
    finally:
        driver.quit()

if __name__ == '__main__':
    main()
