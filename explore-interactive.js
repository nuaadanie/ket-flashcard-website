const puppeteer = require('puppeteer');

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function main() {
  // 启动 Chrome 浏览器
  const browser = await puppeteer.launch({
    headless: 'new', // 使用最新的无头模式
    args: [
      '--no-sandbox',
      '--disable-dev-shm-usage',
      '--disable-gpu',
      '--window-size=1920,1080'
    ],
    timeout: 60000
  });

  // 创建一个新页面
  const page = await browser.newPage();
  await page.setViewport({ width: 1920, height: 1080 });

  try {
    // 导航到服务器上的 standalone.html 文件
    await page.goto('http://localhost:9000/standalone.html', {
      waitUntil: 'domcontentloaded',
      timeout: 120000
    });

    console.log('✅ 页面加载成功');

    // 等待 2 秒让页面完全加载
    await sleep(2000);

    // 检查页面的实际 HTML 结构
    const pageHTML = await page.content();
    console.log('=== 页面的实际 HTML 结构 ===');
    console.log(pageHTML.slice(0, 500));

    // 检查模式切换按钮是否可见
    const modeButtons = await page.$$('.mode-btn');
    console.log('=== 模式切换按钮 ===');
    console.log(`找到 ${modeButtons.length} 个模式切换按钮`);

    for (let i = 0; i < modeButtons.length; i++) {
      const btnText = await page.evaluate(el => el.textContent.trim(), modeButtons[i]);
      const btnDataMode = await page.evaluate(el => el.getAttribute('data-mode'), modeButtons[i]);
      console.log(`按钮 ${i + 1}: 文本 = ${btnText}, data-mode = ${btnDataMode}`);
    }

    // 模拟用户点击"按主题学习"按钮
    let topicModeBtn = null;
    for (let i = 0; i < modeButtons.length; i++) {
      const btnDataMode = await page.evaluate(el => el.getAttribute('data-mode'), modeButtons[i]);
      if (btnDataMode === 'topic') {
        topicModeBtn = modeButtons[i];
        break;
      }
    }

    if (topicModeBtn) {
      await topicModeBtn.click();
      console.log('✅ 点击"按主题学习"按钮');
    } else {
      console.error('❌ 找不到"按主题学习"按钮');
    }

    // 等待主题选择器出现
    const topicSelector = await page.waitForSelector('#topic-selector', {
      visible: true,
      timeout: 10000
    });
    console.log('✅ 主题选择器出现');

    // 模拟用户选择一个主题
    const topicDropdown = await page.waitForSelector('#topic-dropdown', {
      visible: true,
      timeout: 5000
    });
    await topicDropdown.select('Animals（动物）'); // 选择"Animals（动物）"主题
    console.log('✅ 选择"Animals（动物）"主题');

    // 等待单词变化
    await sleep(3000);

    // 获取当前显示的单词
    const currentWord = await page.$eval('#word', el => el.textContent.trim());
    const currentMeaning = await page.$eval('#meaning', el => el.textContent.trim());
    const currentTopicTag = await page.$eval('#topic-tag', el => el.textContent.trim());

    console.log(`✅ 当前显示的单词: ${currentWord}`);
    console.log(`✅ 当前显示的含义: ${currentMeaning}`);
    console.log(`✅ 当前显示的主题: ${currentTopicTag}`);

    // 验证单词是否属于所选主题
    if (currentTopicTag.includes('Animals') || currentTopicTag.includes('动物')) {
      console.log('✅ 单词主题验证成功');
    } else {
      console.error(`❌ 单词主题验证失败，预期: Animals（动物）, 实际: ${currentTopicTag}`);
    }

    // 验证单词是否变化
    if (currentWord) {
      console.log('✅ 单词显示验证成功');
    } else {
      console.error('❌ 单词显示验证失败');
    }

  } catch (error) {
    console.error('❌ 测试过程中出现错误:', error);
  } finally {
    // 关闭浏览器
    await browser.close();
  }
}

main();
