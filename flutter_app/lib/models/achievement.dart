class Achievement {
  final String id;
  final String title;
  final String description;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
  });
}

const achievements = [
  Achievement(id: 'first_word', title: '⭐ 初学乍练', description: '掌握第1个单词'),
  Achievement(id: 'words_10', title: '🌟 小有所成', description: '掌握10个单词'),
  Achievement(id: 'words_50', title: '💫 日积月累', description: '掌握50个单词'),
  Achievement(id: 'words_100', title: '🔥 百词斩', description: '掌握100个单词'),
  Achievement(id: 'words_500', title: '👑 千词之路', description: '掌握500个单词'),
  Achievement(id: 'words_1000', title: '🏆 词汇大师', description: '掌握1000个单词'),
  Achievement(id: 'streak_3', title: '📅 三日之约', description: '连续学习3天'),
  Achievement(id: 'streak_7', title: '🗓️ 周常学习', description: '连续学习7天'),
  Achievement(id: 'streak_30', title: '🎯 月度战士', description: '连续学习30天'),
  Achievement(id: 'level1_done', title: '🖤 黑1毕业', description: '掌握所有黑1单词'),
  Achievement(id: 'level2_done', title: '💙 蓝2毕业', description: '掌握所有蓝2单词'),
  Achievement(id: 'level3_done', title: '❤️ 红3毕业', description: '掌握所有红3单词'),
];
