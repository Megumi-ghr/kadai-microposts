class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.favor(micropost)
    flash[:success] = "メッセージをお気に入りにしました。"
    redirect_back(fallback_location: root_path)
  end

  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.unfavor(micropost)
    flash[:success] = "メッセージのお気に入りを解除しました。"
    redirect_back(fallback_location: root_path)
  end
end
