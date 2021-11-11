class MessagesController < ApplicationController


 def show
  #BさんのUser情報を取得
   @user = User.find(params[:id])
  #user_roomsテーブルのuser_idがAさんのレコードのroom_idを配列で取得
   conversations = current_user.user_rooms.pluck(:conversation_id)
  #user_idがBさん(@user)で、room_idがAさんの属するroom_id（配列）となるuser_roomsテーブルのレコードを取得して、user_room変数に格納
  #これによって、AさんとBさんに共通のroom_idが存在していれば、その共通のroom_idとBさんのuser_idがuser_room変数に格納される（1レコード）。存在しなければ、nilになる。
   user_room = UserRoom.find_by(user_id: @user.id, conversation_id: conversations)
#常に　nil
  #user_roomでルームを取得できなかった（AさんとBさんのチャットがまだ存在しない）場合の処理
   if user_room.nil?
   #roomのidを採番
    @conversation = Conversation.new
    @conversation.save
    #採番したroomのidを使って、user_roomのレコードを2人分（Aさん用、Ｂさん用）作る（＝AさんとBさんに共通のroom_idを作る）
    #Bさんの@user.idをuser_idとして、room.idをroom_idとして、UserRoomモデルのがラムに保存（1レコード）
     UserRoom.create(user_id: @user.id, conversation_id: @conversation.id)
    #Aさんのcurrent_user.idをuser_idとして、room.idをroom_idとして、UserRoomモデルのカラムに保存（1レコード）
     UserRoom.create(user_id: current_user.id, conversation_id: @conversation.id)
   else
    #user_roomに紐づくroomsテーブルのレコードをroomに格納
     @conversation = user_room.conversation
   end

   #roomに紐づくchatsテーブルのレコードを@chatsに格納
    @conversations = @conversation.messages
   #form_withでチャットを送信する際に必要な空のインスタンス
   #ここでroom.idを@chatに代入しておかないと、form_withで記述するroom_idに値が渡らない
    @message = Message.new(conversation_id: @conversation.id)
  end

  def create
    @message = current_user.messages.new(message_params)
    @message.save
    redirect_to request.referer
  end


  private

  def message_params
    params.require(:message).permit(:body, :conversation_id)
  end
end
