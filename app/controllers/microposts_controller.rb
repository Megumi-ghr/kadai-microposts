class MicropostsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to root_url
    else
      @microposts = current_user.feed_microposts.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render 'toppages/index'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  def liked
    @micropost = Micropost.find(params[:id])
    @liked = @micropost.liked.page(params[:page])
  end
  
  def show
    unless @micropost = Micropost.find_by(id: params[:id])
      redirect_to root_url
    end
  end

  def edit
    @micropost = Micropost.find(params[:id])
  end
  
  def update
    @micropost = Micropost.find(params[:id])

    if @micropost.update(micropost_params)
      flash[:success] = 'メッセージを更新しました'
      redirect_to @micropost
    else
      flash.now[:danger] = 'メッセージを更新できませんでした'
      render :edit
    end
  end
  
  private

  def micropost_params
    params.require(:micropost).permit(:content)
  end
  
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    unless @micropost
      redirect_to root_url
    end
  end
end
