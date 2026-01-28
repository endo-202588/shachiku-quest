%w[
  生真面目 明るい 大ざっぱ 楽観的
  物静か 几帳面 好奇心旺盛 人見知り
  おしゃべり 聞き上手 マイペース 負けず嫌い
].each do |name|
  PersonalityTag.find_or_create_by!(name: name)
end
