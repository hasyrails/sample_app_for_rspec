module LoginModule
  def login(user)
    # ログイン画面へ遷移
    visit login_path

    # ログイン情報を入力
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'pwd'

    # ログイン情報を送信
    click_button 'Login'
  end
end
