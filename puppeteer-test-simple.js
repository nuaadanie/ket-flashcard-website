const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

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
        '--window-size=1920,1080'
      ],
      timeout: 60000 // 增加启动超时时间
    });

    const page = await browser.newPage();
    await page.setViewport({ width: 1920, height: 1080 });
    await page.setDefaultNavigationTimeout(60000); // 增加导航超时时间
    await page.setDefaultTimeout(60000); // 增加默认超时时间

    // 获取测试文件的本地路径
    const testFilePath = path.resolve(__dirname, 'standalone.html');
    const testURL = `file://${testFilePath}`;

    console.log('=== 访问 standalone.html 文件 ===');
    await page.goto(testURL, {
      waitUntil: 'domcontentloaded', // 等待 DOM 内容加载完成
      timeout: 60000
    });
    console.log('✅ 页面加载成功');

    // 等待页面加载完成
    await page.waitForSelector('#flashcard', { timeout: 30000 });
    await new Promise(resolve => setTimeout(resolve, 2000)); // 等待 2 秒以确保页面完全加载

    // 验证页面标题
    const title = await page.title();
    if (title === 'KET单词闪卡') {
      console.log('✅ 页面标题验证成功');
    } else {
      console.log(`❌ 页面标题验证失败，预期: "KET单词闪卡"，实际: "${title}"`);
    }

    // 测试主题选择功能（简化版本）
    console.log('\\n=== 测试主题选择功能 ===');
    try {
      // 切换到主题模式
      await page.click('[data-mode="topic"]');
      await new Promise(resolve => setTimeout(resolve, 2000));

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
      await page.waitForSelector('#topic-dropdown', { timeout: 10000 });
      await new Promise(resolve => setTimeout(resolve, 1000));

      // 获取主题下拉菜单的选项
      const options = await page.evaluate(() => {
        const select = document.getElementById('topic-dropdown');
        return Array.from(select.options).map(option => option.value);
      });

      console.log(`✅ 主题下拉菜单包含 ${options.length} 个选项`);

    } catch (error) {
      console.log(`❌ 主题选择功能测试失败: ${error.message}`);
    }

    // 测试单词显示功能
    console.log('\\n=== 测试单词显示功能 ===');
    try {
      const wordText = await page.evaluate(() => {
        return document.getElementById('word').textContent;
      });

      const meaningText = await page.evaluate(() => {
        return document.getElementById('meaning').textContent;
      });

      const topicTagText = await page.evaluate(() => {
        return document.getElementById('topic-tag').textContent;
      });

      if (wordText && wordText.length > 0) {
        console.log(`✅ 单词显示: ${wordText}`);
      } else {
        console.log('❌ 单词未显示');
      }

      if (meaningText && meaningText.length > 0) {
        console.log(`✅ 单词含义: ${meaningText}`);
      } else {
        console.log('❌ 单词含义未显示');
      }

      if (topicTagText && topicTagText.length > 0) {
        console.log(`✅ 主题标签: ${topicTagText}`);
      } else {
        console.log('❌ 主题标签未显示');
      }

    } catch (error) {
      console.log(`❌ 单词显示功能测试失败: ${error.message}`);
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
