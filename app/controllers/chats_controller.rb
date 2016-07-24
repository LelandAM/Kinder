class ChatsController < ApplicationController
  def index
    @chats = current_user.subscriptions
    @chat = Chat.new
  end

  def new
    @chat = Chat.new
  end

   def create
    @chat = Chat.new(chat_params)
    if @chat.save
      respond_to do |format|
        format.html { redirect_to @chat }
        format.js
      end
    else
      respond_to do |format|
        flash[:notice] = {error: ["a chatroom with this topic already exists"]}
        format.html { redirect_to new_chat_path }
        # format.js { render template: 'chats/chat_error.js.erb'}
      end
    end
  end

  def show
    @chat = Chat.find_by(id: params[:id])
    @message = Message.new
  end

   private

    def chat_params
      params.require(:chat).permit(:identifier)
    end
end

