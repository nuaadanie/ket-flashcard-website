const puppeteer = require('puppeteer');

async function testLocalStorage() {
    console.log("🚀 启动浏览器...");
    const browser = await puppeteer.launch({
        headless: true,
        args: ['--no-sandbox', '--disable-setuid-sandbox']
    });
    const page = await browser.newPage();
    page.setViewport({ width: 1280, height: 800 });

    try {
        console.log("📱 访问单词闪卡应用...");
        await page.goto('http://localhost:8081', { timeout: 20000 });

        console.log("⏳ 等待页面加载完成...");
        await page.waitForSelector('#total-count', { timeout: 15000 });

        // 检查当前已会单词数
        let initialCount = await page.$eval('#mastered-count', el => el.textContent);
        console.log(`📊 当前已会单词数: ${initialCount}`);

        // 点击"已会"按钮来标记单词
        console.log("✅ 点击'已会'按钮...");
        await page.click('#mastered-btn');
        await new Promise(resolve => setTimeout(resolve, 1500));

        // 检查已会单词数是否增加
        let afterClickCount = await page.$eval('#mastered-count', el => el.textContent);
        console.log(`📈 点击后已会单词数: ${afterClickCount}`);

        // 验证已会单词数是否增加
        if (parseInt(afterClickCount) > parseInt(initialCount)) {
            console.log("✅ 已会单词数正确增加");
        } else {
            console.error("❌ 已会单词数未增加");
        }

        // 检查本地存储是否已更新
        console.log("💾 检查本地存储数据...");
        const localStorageData = await page.evaluate(() => {
            return localStorage.getItem('ket-flashcard');
        });

        if (localStorageData) {
            const parsedData = JSON.parse(localStorageData);
            console.log(`✅ 本地存储数据长度: ${localStorageData.length} 字符`);

            if (parsedData.mastered && parsedData.mastered.length > 0) {
                console.log(`✅ 已会单词数组包含 ${parsedData.mastered.length} 个单词`);
            }

            // 检查数据是否完整
            if (parsedData.unknown) {
                console.log(`ℹ️  不会单词数组包含 ${parsedData.unknown.length} 个单词`);
            }

            if (parsedData.levelProgress) {
                console.log(`ℹ️  级别进度数据存在`);
            }

            if (parsedData.topicProgress) {
                console.log(`ℹ️  主题进度数据存在`);
            }
        } else {
            console.error("❌ 本地存储中没有找到 ket-flashcard 数据");
        }

        // 刷新页面测试数据恢复
        console.log("\n🔄 刷新页面测试数据恢复...");
        await page.reload({ waitUntil: 'domcontentloaded' });

        console.log("⏳ 等待页面刷新完成...");
        await page.waitForSelector('#total-count', { timeout: 10000 });
        await new Promise(resolve => setTimeout(resolve, 1000));

        // 检查刷新后已会单词数是否与之前一致
        let afterRefreshCount = await page.$eval('#mastered-count', el => el.textContent);
        console.log(`📊 刷新后已会单词数: ${afterRefreshCount}`);

        if (parseInt(afterRefreshCount) === parseInt(afterClickCount)) {
            console.log("✅ 页面刷新后已会单词数正确恢复");
        } else {
            console.error("❌ 页面刷新后已会单词数未恢复，原始值: ", afterClickCount, " 当前值: ", afterRefreshCount);
        }

        // 验证刷新后本地存储数据是否仍然存在
        const localStorageDataAfterRefresh = await page.evaluate(() => {
            return localStorage.getItem('ket-flashcard');
        });

        if (localStorageDataAfterRefresh) {
            console.log("✅ 本地存储数据在页面刷新后仍然存在");
        } else {
            console.error("❌ 页面刷新后本地存储数据丢失");
        }

        console.log("\n🎉 测试完成！");

    } catch (error) {
        console.error("❌ 测试过程中出错: ", error);
    } finally {
        await browser.close();
    }
}

testLocalStorage();
