const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

// 测试主题列表
const testTopics = [
  'Animals（动物）',
  'Clothes（衣物）',
  'Food & drink（食物与饮料）',
  'Sports & leisure (Continued)（运动与休闲 续）'
];

async function runTests() {
  let browser;
  try {
    console.log('=== 启动无头 Chrome 浏览器 ===');
    browser = await puppeteer.launch({
      headless: 'new', // 使用最新版本的无头模式
      args: [
        '--no-sandbox',
        '--disable-dev-shm-usage',
        '--disable-gpu',
        '--window-size=1920,1080',
        '--ignore-certificate-errors',
        '--disable-extensions',
        '--disable-popup-blocking'
      ]
    });

    const page = await browser.newPage();
    await page.setViewport({ width: 1920, height: 1080 });

    // 通过服务器访问 standalone.html 文件
    const testURL = 'http://localhost:9001/standalone.html';

    console.log('=== 访问 standalone.html 文件 ===');
    await page.goto(testURL, { waitUntil: 'networkidle2', timeout: 60000 });
    console.log('✅ 页面加载成功');

    // 验证页面标题
    const title = await page.title();
    if (title === 'KET单词闪卡') {
      console.log('✅ 页面标题验证成功');
    } else {
      console.log(`❌ 页面标题验证失败，预期: "KET单词闪卡"，实际: "${title}"`);
    }

    // 测试主题选择功能
    console.log('\\n=== 测试主题选择功能 ===');
    try {
      // 切换到主题模式
      await page.click('[data-mode="topic"]');
      await new Promise(resolve => setTimeout(resolve, 1000));

      // 验证主题模式是否激活
      const isActive = await page.evaluate(() => {
        const btn = document.querySelector('[data-mode="topic"]');
        return btn.classList.contains('bg-green-500') && btn.classList.contains('text-white');
      });

      if (isActive) {
        console.log('✅ 主题模式激活成功');
      } else {
        console.log('❌ 主题模式激活失败');
      }

      // 等待主题选择器出现
      await page.waitForSelector('#topic-dropdown', { timeout: 5000 });
      await new Promise(resolve => setTimeout(resolve, 1000));

      // 获取主题下拉菜单的选项
      const options = await page.evaluate(() => {
        const select = document.getElementById('topic-dropdown');
        return Array.from(select.options).map(option => option.value);
      });

      console.log(`✅ 主题下拉菜单包含 ${options.length} 个选项`);

      // 测试选择主题
      for (let i = 0; i < testTopics.length; i++) {
        const topic = testTopics[i];
        console.log(`\\n=== 测试主题: ${topic} ===`);

        try {
          // 选择主题
          await page.select('#topic-dropdown', topic);
          await new Promise(resolve => setTimeout(resolve, 1000));

          // 验证单词是否显示
          const wordText = await page.evaluate(() => {
            return document.getElementById('word').textContent;
          });

          const meaningText = await page.evaluate(() => {
            return document.getElementById('meaning').textContent;
          });

          const topicTagText = await page.evaluate(() => {
            return document.getElementById('topic-tag').textContent;
          });

          console.log(`✅ 单词显示: ${wordText}`);
          console.log(`✅ 单词含义: ${meaningText}`);

          if (topicTagText === topic) {
            console.log('✅ 主题标签验证成功');
          } else {
            console.log(`❌ 主题标签验证失败，预期: "${topic}"，实际: "${topicTagText}"`);
          }

        } catch (error) {
          console.log(`❌ 主题测试失败: ${error.message}`);
        }
      }

    } catch (error) {
      console.log(`❌ 主题选择功能测试失败: ${error.message}`);
    }

    // 测试单词本功能
    console.log('\\n=== 测试单词本功能 ===');
    try {
      // 点击单词本按钮
      await page.click('#vocab-btn');
      await new Promise(resolve => setTimeout(resolve, 2000));

      // 验证单词本是否打开
      const modalVisible = await page.evaluate(() => {
        const modal = document.querySelector('.vocab-modal');
        return modal && modal.offsetParent !== null;
      });

      if (modalVisible) {
        console.log('✅ 单词本打开成功');
      } else {
        console.log('❌ 单词本打开失败');
      }

      // 关闭单词本
      await page.click('#close-vocab');
      await new Promise(resolve => setTimeout(resolve, 1000));

    } catch (error) {
      console.log(`❌ 单词本功能测试失败: ${error.message}`);
    }

    // 测试发音功能
    console.log('\\n=== 测试发音功能 ===');
    try {
      // 点击发音按钮
      await page.click('#play-btn');
      console.log('✅ 发音按钮点击成功');
      await new Promise(resolve => setTimeout(resolve, 2000));

    } catch (error) {
      console.log(`❌ 发音功能测试失败: ${error.message}`);
    }

  } catch (error) {
    console.log('❌ 测试过程中发生错误');
    console.error('错误信息:', error);
  } finally {
    if (browser) {
      console.log('\\n=== 关闭浏览器 ===');
      await browser.close();
    }
  }
}

// 运行测试
runTests().catch(error => {
  console.log('❌ 测试执行失败');
  console.error('错误信息:', error);
});
