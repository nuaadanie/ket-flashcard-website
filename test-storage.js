const puppeteer = require('puppeteer');

async function testStorage() {
    const browser = await puppeteer.launch({
        headless: true,
        args: ['--no-sandbox', '--disable-setuid-sandbox']
    });
    const page = await browser.newPage();
    page.setViewport({ width: 1280, height: 800 });

    console.log('=== 1. 测试页面初始化和本地存储 ===');
    try {
        await page.goto('http://localhost:8081', { timeout: 15000 });
        await page.waitForSelector('#mastered-count', { timeout: 10000 });
        await new Promise(resolve => setTimeout(resolve, 1000));
    } catch (error) {
        console.error(`❌ 页面加载超时: ${error}`);
        await browser.close();
        return;
    }

    // 检查初始状态
    const initialMastered = await page.$eval('#mastered-count', el => el.textContent);
    console.log(`   初始已会单词数: ${initialMastered}`);

    console.log('\n=== 2. 测试标记单词为已会 ===');
    const masteredBtn = await page.$('#mastered-btn');
    if (masteredBtn) {
        await masteredBtn.click();
        await new Promise(resolve => setTimeout(resolve, 1500));
        const afterClickMastered = await page.$eval('#mastered-count', el => el.textContent);
        console.log(`   点击后已会单词数: ${afterClickMastered}`);

        if (parseInt(afterClickMastered) > parseInt(initialMastered)) {
            console.log('✅ 标记单词为已会功能正常');
        } else {
            console.error('❌ 标记单词为已会功能失败');
        }
    }

    console.log('\n=== 3. 测试本地存储 ===');
    // 检查 localStorage
    const ketFlashcardData = await page.evaluate(() => localStorage.getItem('ket-flashcard'));
    if (ketFlashcardData) {
        const parsedData = JSON.parse(ketFlashcardData);
        console.log(`✅ 本地存储数据已保存: ket-flashcard (${ketFlashcardData.length} bytes)`);
        if (parsedData.mastered && parsedData.mastered.length > 0) {
            console.log(`✅ 已会单词数组包含 ${parsedData.mastered.length} 个单词`);
        } else {
            console.error('❌ 已会单词数组为空');
        }
    } else {
        console.error('❌ 本地存储中没有 ket-flashcard 数据');
    }

    console.log('\n=== 4. 测试页面刷新后本地存储恢复 ===');
    await page.reload();
    await page.waitForSelector('#mastered-count');
    await new Promise(resolve => setTimeout(resolve, 2000));

    const afterRefreshMastered = await page.$eval('#mastered-count', el => el.textContent);
    console.log(`   刷新后已会单词数: ${afterRefreshMastered}`);

    // 验证数据是否一致
    const ketFlashcardDataAfter = await page.evaluate(() => localStorage.getItem('ket-flashcard'));
    if (ketFlashcardDataAfter) {
        const parsedDataAfter = JSON.parse(ketFlashcardDataAfter);
        if (parsedDataAfter.mastered.length > 0) {
            console.log('✅ 页面刷新后数据已正确恢复');
        } else {
            console.error('❌ 页面刷新后已会单词数为0');
        }
    } else {
        console.error('❌ 页面刷新后本地存储数据不存在');
    }

    console.log('\n=== 5. 清理测试数据 ===');
    await page.evaluate(() => localStorage.removeItem('ket-flashcard'));

    await browser.close();
    console.log('\n✅ 测试完成');
}

testStorage().catch(err => {
    console.error('❌ 测试过程中出错:', err);
});
