const puppeteer = require('puppeteer');

async function waitForTimeout(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function testFlashcardApp() {
    console.log('启动浏览器...');
    const browser = await puppeteer.launch({ headless: true });
    const page = await browser.newPage();
    page.setViewport({ width: 1280, height: 800 });

    console.log('访问页面...');
    await page.goto('http://localhost:8081');

    // 等待页面加载完成
    await page.waitForSelector('#total-count');
    await waitForTimeout(2000); // 等待2秒确保数据加载

    // 检查页面是否显示
    const title = await page.title();
    console.log(`页面标题: ${title}`);
    if (title !== 'KET单词闪卡') {
        console.error('页面标题不正确');
    }

    // 检查总词数是否大于0
    const totalCount = await page.$eval('#total-count', el => el.textContent);
    console.log(`总词数: ${totalCount}`);
    if (parseInt(totalCount) === 0) {
        console.error('词汇数据未加载');
    }

    // 测试学习模式切换
    console.log('测试学习模式切换...');
    const topicBtn = await page.$('[data-mode="topic"]');
    if (topicBtn) {
        await topicBtn.click();
        await waitForTimeout(1000);

        // 检查按钮样式
        const topicBtnClass = await page.evaluate(el => el.className, topicBtn);
        if (topicBtnClass.includes('bg-green-500')) {
            console.log('✅ 主题模式按钮激活成功');
        } else {
            console.error('❌ 主题模式按钮激活失败');
        }

        // 检查级别按钮是否变为灰色
        const levelBtn = await page.$('[data-mode="level"]');
        const levelBtnClass = await page.evaluate(el => el.className, levelBtn);
        if (levelBtnClass.includes('bg-gray-100')) {
            console.log('✅ 级别模式按钮已灰色化');
        } else {
            console.error('❌ 级别模式按钮未灰色化');
        }

        // 检查主题选择器是否可见
        const topicSelectorVisible = await page.evaluate(el => !el.classList.contains('hidden'), await page.$('#topic-selector'));
        if (topicSelectorVisible) {
            console.log('✅ 主题选择器已显示');
        } else {
            console.error('❌ 主题选择器未显示');
        }
    }

    // 测试级别模式切换
    console.log('测试级别模式切换...');
    const levelBtn = await page.$('[data-mode="level"]');
    if (levelBtn) {
        await levelBtn.click();
        await waitForTimeout(1000);

        const levelBtnClass = await page.evaluate(el => el.className, levelBtn);
        if (levelBtnClass.includes('bg-green-500')) {
            console.log('✅ 级别模式按钮激活成功');
        } else {
            console.error('❌ 级别模式按钮激活失败');
        }
    }

    // 测试页面刷新后的本地存储
    console.log('测试页面刷新后的本地存储...');
    // 先点击几个单词标记为已会
    const masteredBtn = await page.$('#mastered-btn');
    if (masteredBtn) {
        await masteredBtn.click();
        await waitForTimeout(1000);
    }

    // 刷新页面
    await page.reload();
    await page.waitForSelector('#mastered-count');
    await waitForTimeout(2000);

    const masteredCount = await page.$eval('#mastered-count', el => el.textContent);
    if (parseInt(masteredCount) > 0) {
        console.log(`✅ 页面刷新后数据已保存，已会单词数: ${masteredCount}`);
    } else {
        console.error('❌ 页面刷新后数据未保存');
    }

    console.log('测试完成！');
    await browser.close();
}

testFlashcardApp().catch(error => {
    console.error('测试过程中发生错误:', error);
});
