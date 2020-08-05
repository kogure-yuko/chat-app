require 'rails_helper'

RSpec.describe "ユーザーログイン機能", type: :system do
  it "ログインしていない場合、サインページに移動する" do
    # トップページに移動する
    visit root_path

    # ログインしていない場合、サインインページに移動することを期待する
    expect(current_path).to eq new_user_session_path
  end
  
  it "ログインに成功し、ルートパスに遷移する" do
    # 予めユーザーをDBに保存する
    @user = FactoryBot.create(:user)

    # サインインペ時に移動する
    visit new_user_session_path

    # ログインしていない場合、サインインページに遷移することを期待する
    expect(current_path).to eq new_user_session_path
    
    # すでに保存されているユーザーのemailとpasswordを入力する
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: @user.password

    # ログインボタンをクリックする
    find('input[name="commit"]').click

    # ルートページに遷移することを期待する
    expect(current_path).to eq root_path
  end

  it "ログインに失敗して再びサインインページに戻ってくる" do
    # # 予めユーザーをDBに保存する
    @user = FactoryBot.create(:user)

    # サインインペ時に移動する
    visit new_user_session_path

    # ログインしていない場合、サインインページに遷移することを期待する
    expect(current_path).to eq new_user_session_path
    
    # 誤ったユーザー情報を入力する
    fill_in "user_email", with: "hugahuga"
    fill_in "user_password", with: "hogehoge"

    # ログインボタンをクリックする
    click_on("Log in")

    # サインインページに戻される
    expect(current_path).to eq new_user_session_path
  end
end
