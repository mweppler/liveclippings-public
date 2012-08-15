class FollowingsController < ApplicationController

  layout 'public'

  before_filter :confirm_logged_in

  def delete
    Following.delete_all(:user_id => current_user.id, :follow_id => params[:id])
    flash[:notice] = "Relationship Deleted"
    redirect_to(:action => 'followings')
  end

  def follow
    following = Following.new
    following.user_id = current_user.id
    following.follow_id = params[:id]
    if following.save
      flash[:notice] = "Following User!"
      redirect_to(:action => 'followings')
    else
      flash[:notice] = following.errors
      redirect_to(:action => 'search')
    end
  end

  def followings
    @followings = Following.where("user_id=:user_id", {:user_id => current_user.id})
  end

  def search
    if !params[:search_by].nil? && !params[:search_by].empty? && !params[:search].nil? && !params[:search].empty?
      search_by = params[:search_by]
      @users = User.where("#{search_by}=:search", {:search => params[:search]}).all
    end
  end

end