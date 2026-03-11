const fs = require('fs');

try {
    const htmlContent = fs.readFileSync('standalone.html', 'utf8');

    // 提取所有 <script> 标签内容
    const scriptTags = htmlContent.match(/<script>([\s\S]*?)<\/script>/g);

    if (scriptTags) {
        console.log(`✅ 找到 ${scriptTags.length} 个 script 标签`);

        scriptTags.forEach((tag, index) => {
            console.log(`\n📄 Script ${index + 1}:`);

            // 去除标签本身
            const scriptContent = tag.replace(/<script>|<\/script>/g, '').trim();

            try {
                // 尝试提取 wordData
                if (scriptContent.includes('const wordData')) {
                    console.log('   包含 wordData 变量');

                    const wordDataMatch = scriptContent.match(/const wordData = ({[\s\S]*?});/);
                    if (wordDataMatch) {
                        const wordData = JSON.parse(wordDataMatch[1]);
                        console.log('   ✅ wordData 解析成功');
                        console.log(`      版本: ${wordData.version}`);
                        console.log(`      总词数: ${wordData.total}`);
                        console.log(`      级别数: ${wordData.levels.length}`);
                        console.log(`      主题数: ${wordData.topics.length}`);
                        console.log(`      单词数: ${wordData.words.length}`);
                    }
                }

                // 检查是否包含其他关键函数
                const keyFunctions = ['loadWords', 'initUI', 'filterWordsByLevel', 'renderTopicButtons', 'markUnknown', 'markMastered', 'playWord', 'updateStats'];
                keyFunctions.forEach(func => {
                    if (scriptContent.includes(`function ${func}`)) {
                        console.log(`   ✅ 找到函数: ${func}`);
                    }
                });

            } catch (error) {
                console.log(`   ❌ 解析错误: ${error.message}`);
                if (error.stack) {
                    console.log(`      📚 堆栈信息: ${error.stack}`);
                }

                // 打印错误位置附近的代码
                const errorPos = scriptContent.indexOf('const wordData');
                if (errorPos !== -1) {
                    const start = Math.max(0, errorPos - 50);
                    const end = Math.min(errorPos + 200, scriptContent.length);
                    console.log('      📝 相关代码片段:');
                    console.log(`      ${scriptContent.substring(start, end)}`);
                }
            }
        });
    } else {
        console.log('❌ 未找到 script 标签');
    }

} catch (error) {
    console.log(`❌ 读取文件失败: ${error.message}`);
    if (error.stack) {
        console.log(`📚 堆栈信息: ${error.stack}`);
    }
}
