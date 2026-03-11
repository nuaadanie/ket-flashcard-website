const { Builder, By, until } = require('selenium-webdriver');
const chrome = require('selenium-webdriver/chrome');
const fs = require('fs');
const path = require('path');

// 配置无头 Chrome 选项
const options = new chrome.Options();
options.addArguments('--headless');
options.addArguments('--no-sandbox');
options.addArguments('--disable-dev-shm-usage');
options.addArguments('--disable-gpu');
options.addArguments('--window-size=1920,1080');

// 测试主题列表
const testTopics = [
  'Animals（动物）',
  'Clothes（衣物）',
  'Food & drink（食物与饮料）',
  'Sports & leisure (Continued)（运动与休闲 续）'
];

async function runTests() {
  let driver;
  try {
    console.log('=== 启动无头 Chrome 浏览器 ===');
    driver = await new Builder()
      .forBrowser('chrome')
      .setChromeOptions(options)
      .build();

    // 获取测试文件的本地路径
    const testFilePath = path.resolve(__dirname, 'standalone.html');
    const testURL = `file://${testFilePath}`;

    console.log('=== 访问 standalone.html 文件 ===');
    await driver.get(testURL);
    console.log('✅ 页面加载成功');

    // 等待页面加载完成
    await driver.wait(until.elementLocated(By.id('flashcard')), 10000);
    await driver.sleep(2000); // 等待 2 秒以确保页面完全加载

    // 验证页面标题
    const title = await driver.getTitle();
    if (title === 'KET单词闪卡') {
      console.log('✅ 页面标题验证成功');
    } else {
      console.log(`❌ 页面标题验证失败，预期: "KET单词闪卡"，实际: "${title}"`);
    }

    // 测试主题选择
    console.log('\\n=== 测试主题选择功能 ===');
    await testTopicSelection(driver);

    // 测试单词本功能
    console.log('\\n=== 测试单词本功能 ===');
    await testVocabBook(driver);

    // 测试发音功能
    console.log('\\n=== 测试发音功能 ===');
    await testPronunciation(driver);

  } catch (error) {
    console.log('❌ 测试过程中发生错误');
    console.error('错误信息:', error);
  } finally {
    if (driver) {
      console.log('\\n=== 关闭浏览器 ===');
      await driver.quit();
    }
  }
}

async function testTopicSelection(driver) {
  try {
    // 切换到主题模式
    const topicModeBtn = await driver.findElement(By.css('[data-mode="topic"]'));
    await topicModeBtn.click();
    await driver.sleep(1000);

    // 验证主题模式是否激活
    const activeBtn = await driver.findElement(By.css('[data-mode="topic"].bg-green-500'));
    if (activeBtn) {
      console.log('✅ 主题模式激活成功');
    } else {
      console.log('❌ 主题模式激活失败');
    }

    // 等待主题选择器出现
    await driver.wait(until.elementLocated(By.id('topic-selector')), 5000);
    await driver.sleep(1000);

    // 获取主题下拉菜单
    const topicDropdown = await driver.findElement(By.id('topic-dropdown'));

    // 测试每个主题
    for (let i = 0; i < testTopics.length; i++) {
      const topic = testTopics[i];
      console.log(`\\n=== 测试主题: ${topic} ===`);

      try {
        // 选择主题
        await topicDropdown.sendKeys(topic);
        await driver.sleep(1000);

        // 验证单词是否显示
        const wordElement = await driver.findElement(By.id('word'));
        const wordText = await wordElement.getText();
        console.log(`✅ 单词显示: ${wordText}`);

        const meaningElement = await driver.findElement(By.id('meaning'));
        const meaningText = await meaningElement.getText();
        console.log(`✅ 单词含义: ${meaningText}`);

        const topicTagElement = await driver.findElement(By.id('topic-tag'));
        const topicTagText = await topicTagElement.getText();
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
}

async function testVocabBook(driver) {
  try {
    // 点击单词本按钮
    const vocabBtn = await driver.findElement(By.id('vocab-btn'));
    await vocabBtn.click();
    await driver.sleep(2000);

    // 验证单词本是否打开
    const modal = await driver.findElement(By.className('vocab-modal'));
    if (modal) {
      console.log('✅ 单词本打开成功');
    } else {
      console.log('❌ 单词本打开失败');
    }

    // 关闭单词本
    const closeBtn = await driver.findElement(By.id('close-vocab'));
    await closeBtn.click();
    await driver.sleep(1000);

  } catch (error) {
    console.log(`❌ 单词本功能测试失败: ${error.message}`);
  }
}

async function testPronunciation(driver) {
  try {
    // 点击发音按钮
    const playBtn = await driver.findElement(By.id('play-btn'));
    await playBtn.click();
    console.log('✅ 发音按钮点击成功');
    await driver.sleep(2000);

  } catch (error) {
    console.log(`❌ 发音功能测试失败: ${error.message}`);
  }
}

// 运行测试
runTests().catch(error => {
  console.log('❌ 测试执行失败');
  console.error('错误信息:', error);
});
