require 'rails_helper'

RSpec.describe "Messages", type: :system do
  before do
    @room_user = FactoryBot.create(:room_user)
  end

  context "投稿に失敗したとき" do
    it "送る値が空のため、メッセージの送信に失敗すること" do
      # サインインする
      sign_in(@room_user.user)

      # 作成したチャットルームへ移動する
      click_on(@room_user.room.name)

      # DBに保存されていないことを期待する
      expect{
        click_on("送信")
      }.not_to change { Message.count }

      # 元のページに戻ってくることを期待する
      expect(current_path).to eq room_messages_path(@room_user.room)
    end
  end

  context "投稿に成功したとき" do
    it "テキストの投稿に成功すると、投稿一覧に移動して、投稿した内容が表示される" do
      # サインインする
      sign_in(@room_user.user)

      # 作成したチャットルームに移動する
      click_on(@room_user.room.name)

      # 値をテキストフォームに入れる
      post = "hogehoge"
      fill_in "message_content", with: post

      # 送信した値がDBに保存されていることを期待する
      expect{
        click_on("送信")
    }.to change{ Message.count }.by(1)

      # 投稿一覧画面に遷移することを期待する
      expect(current_path).to eq room_messages_path(@room_user.room)

      # 送信した値がブラウザに表示されていることを期待する
      expect(page).to have_content post
    end
  end

  it "画像の投稿に成功すると、投稿一覧に移動して、投稿した内容が表示される" do 
    # サインインする
    sign_in(@room_user.user)

    # 作成したチャットルームに移動する
    click_on(@room_user.room.name)

    # 添付する画像を定義する
    image_path = Rails.root.join('public/images/test_image.png')

    # 画像選択フォームに画像を添付する
    attach_file('message_image', image_path, make_visible: true)

    # 送信した値がDBに保存されていることを期待する
    expect{
      click_on("送信")
  }.to change{ Message.count }.by(1)

    # 投稿一覧画面に遷移することを期待する
    expect(current_path).to eq room_messages_path(@room_user.room)

    # 送信した値がブラウザに表示されていることを期待する
    expect(page).to have_selector ("img")
  end

  it "画像とテキストの投稿に成功すること" do
    # サインインする
    sign_in(@room_user.user)

    # 作成したチャットルームに移動する
    click_on(@room_user.room.name)

    # 添付する画像を定義する
    image_path = Rails.root.join('public/images/test_image.png')

    # 画像選択フォームに画像を添付する
    attach_file('message_image', image_path, make_visible: true)

    # 値をテキストフォームに入れる
      post = "hogehoge"
      fill_in "message_content", with: post

    # 送信した値がDBに保存されていることを期待する
    expect{
      click_on("送信")
    }.to change{ Message.count }.by(1)

    # 投稿一覧画面に遷移することを期待する
    expect(current_path).to eq room_messages_path(@room_user.room)

    # 送信した値がブラウザに表示されていることを期待する
    expect(page).to have_selector ("img")
    expect(page).to have_content post
  end
end
