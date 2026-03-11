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
options.addArguments('--ignore-certificate-errors');
options.addArguments('--disable-extensions');
options.addArguments('--disable-popup-blocking');

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

    // 测试主题选择功能（简单测试）
    console.log('\\n=== 测试主题选择功能 ===');
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

      // 验证下拉菜单是否有选项
      const optionsCount = await topicDropdown.findElements(By.css('option')).then(elements => elements.length);
      if (optionsCount > 1) {
        console.log(`✅ 主题下拉菜单包含 ${optionsCount} 个选项（包含默认选项）`);
      } else {
        console.log('❌ 主题下拉菜单没有选项');
      }

    } catch (error) {
      console.log(`❌ 主题选择功能测试失败: ${error.message}`);
    }

    // 测试单词显示功能
    console.log('\\n=== 测试单词显示功能 ===');
    try {
      const wordElement = await driver.findElement(By.id('word'));
      const wordText = await wordElement.getText();
      if (wordText && wordText.length > 0) {
        console.log(`✅ 单词显示: ${wordText}`);
      } else {
        console.log('❌ 单词未显示');
      }

      const meaningElement = await driver.findElement(By.id('meaning'));
      const meaningText = await meaningElement.getText();
      if (meaningText && meaningText.length > 0) {
        console.log(`✅ 单词含义: ${meaningText}`);
      } else {
        console.log('❌ 单词含义未显示');
      }

      const topicTagElement = await driver.findElement(By.id('topic-tag'));
      const topicTagText = await topicTagElement.getText();
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
    if (driver) {
      console.log('\\n=== 关闭浏览器 ===');
      await driver.quit();
    }
  }
}

// 运行测试
runTests().catch(error => {
  console.log('❌ 测试执行失败');
  console.error('错误信息:', error);
});
