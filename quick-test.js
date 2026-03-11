const puppeteer = require('puppeteer');

async function quickTest() {
    console.log('启动浏览器...');
    const browser = await puppeteer.launch({
        headless: true,
        args: ['--no-sandbox', '--disable-setuid-sandbox']
    });
    const page = await browser.newPage();
    page.setViewport({ width: 1280, height: 800 });

    try {
        console.log('访问单词闪卡应用...');
        await page.goto('http://localhost:9001/standalone.html', { timeout: 60000 });

        console.log('等待页面加载完成...');
        await page.waitForSelector('#mastered-count', { timeout: 5000 });

        let initialCount = await page.$eval('#mastered-count', el => el.textContent);
        console.log(`当前已会单词数: ${initialCount}`);

        console.log('点击"已会"按钮...');
        await page.click('#mastered-btn');
        await new Promise(resolve => setTimeout(resolve, 1000));

        let afterClickCount = await page.$eval('#mastered-count', el => el.textContent);
        console.log(`点击后已会单词数: ${afterClickCount}`);

        if (parseInt(afterClickCount) > parseInt(initialCount)) {
            console.log('✅ 已会单词数正确增加');
        } else {
            console.error('❌ 已会单词数未增加');
        }

        // 获取本地存储数据
        const localStorageData = await page.evaluate(() => {
            return localStorage.getItem('ket-flashcard');
        });

        if (localStorageData) {
            try {
                const parsedData = JSON.parse(localStorageData);
                console.log(`✅ 本地存储数据已保存: ${localStorageData.length} 字符`);

                if (parsedData.mastered && parsedData.mastered.length > 0) {
                    console.log(`✅ 已会单词数组包含 ${parsedData.mastered.length} 个单词`);
                }
            } catch (error) {
                console.error(`❌ 解析本地存储数据失败: ${error}`);
            }
        } else {
            console.error('❌ 本地存储中未找到数据');
        }

        console.log('刷新页面...');
        await page.reload({ timeout: 60000 });
        await page.waitForSelector('#mastered-count', { timeout: 5000 });

        let afterRefreshCount = await page.$eval('#mastered-count', el => el.textContent);
        console.log(`刷新后已会单词数: ${afterRefreshCount}`);

        if (parseInt(afterRefreshCount) === parseInt(afterClickCount)) {
            console.log('✅ 页面刷新后数据正确恢复');
        } else {
            console.error(`❌ 页面刷新后数据未恢复，预期: ${afterClickCount}，实际: ${afterRefreshCount}`);
        }

    } catch (error) {
        console.error(`❌ 测试过程中出错: ${error}`);
    }

    await browser.close();
    console.log('测试完成');
}

quickTest();
