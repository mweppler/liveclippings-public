require 'will_paginate/array'

class ClippingsController < ApplicationController

  layout 'public'

  before_filter :confirm_logged_in

  def archive
    # archive clipping
    list
    render('list')
  end

  def copy
    original_clipping = Clipping.where("id = ? AND public = 1", params[:id]).first
    if original_clipping.nil?
      flash[:notice] = "No Clipping to Grab!"
    else
      clipping = Clipping.new
      clipping.user_id = current_user.id
      clipping.content_type = original_clipping.content_type
      clipping.title = original_clipping.title
      clipping.summary = original_clipping.summary
      if clipping.stored_clipping.nil?
        stored_clipping = StoredClipping.new
        stored_clipping.content = ""
        clipping.stored_clipping = stored_clipping
      end
      if "text" === clipping.content_type
        clipping.stored_clipping.content = original_clipping.stored_clipping.content
      else
        if clipping.url != original_clipping.url
          clipping.url = original_clipping.url
          clipping.retrieve_html_content
          clipping.title = clipping.retrieve_title_from_html
          clipping.stored_clipping.content = clipping.retrieve_body_from_html
        end
      end
      clipping.public = original_clipping.public
      clipping.favorite = original_clipping.favorite
      clipping.read = original_clipping.read
      clipping.archive = original_clipping.archive
      if clipping.save
        flash[:notice] = "Clipped!"
      else
        flash[:notice] = "Problem Clipping: #{clipping.errors}"
      end
    end
    redirect_to(:action => 'stream')
  end

  def create
    @clipping = Clipping.new
    @stored_clipping = StoredClipping.new
    @clipping.user_id = session[:user_id]
    @clipping.content_type = params[:content_type]
    if "text" === @clipping.content_type
      @clipping.title = params[:title]
      @clipping.summary = params[:summary]
      @stored_clipping.content = params[:content]
    else
      @clipping.url = params[:url]
      @clipping.retrieve_html_content
      @clipping.title = @clipping.retrieve_title_from_html
      @stored_clipping.content = @clipping.retrieve_body_from_html
    end
    @clipping.stored_clipping = @stored_clipping
    @clipping.public = params[:public]
    @clipping.favorite = params[:favorite]
    @clipping.read = params[:read]
    @clipping.archive = params[:archive]
    if @clipping.save
      flash[:notice] = "Clipping Created"
      redirect_to(:action => 'list')
    else
      render('new')
    end
  end

  def delete
    @clipping = Clipping.find_by_id(params[:id])
    if @clipping.nil?
      flash[:notice] = "That clipping does not exist."
      redirect_to(:action => 'list')
      return false
    end
    if @clipping.user_id == current_user.id
      return @clipping
    else
      @clipping = nil
      flash[:notice] = "That clipping does not exist."
      redirect_to(:action => 'list')
    end
  end

  def destroy
    @clipping = Clipping.find_by_id(params[:id])
    if @clipping.nil?
      flash[:notice] = "That clipping does not exist."
      redirect_to(:action => 'list')
      return false
    end
    if @clipping.user_id == current_user.id
      clip = Clipping.find(params[:id])
      clip.destroy
      flash[:notice] = "Clipping Deleted"
      redirect_to(:action => 'list')
    else
      @clipping = nil
      flash[:notice] = "That clipping does not exist."
      redirect_to(:action => 'list')
    end
  end

  def edit
    @clipping = Clipping.find_by_id(params[:id])
    if @clipping.nil?
      flash[:notice] = "That clipping does not exist."
      redirect_to(:action => 'list')
      return false
    end
    if @clipping.user_id == current_user.id
      return @clipping
    else
      @clipping = nil
      flash[:notice] = "That clipping does not exist."
      redirect_to(:action => 'list')
    end
  end

  def favorite
    # favorite clipping
  end

  def index
    list
    render('list')
  end

  def list
    if params[:search].nil? # not a search
      @clippings = Clipping.paginate(:page => params[:page], :per_page => 25, :conditions => ['user_id = ?', current_user.id], :order => 'updated_at DESC')
    elsif request.xhr? and params[:search] # search via xhr request (ajax)
      @clippings = Clipping.search params[:search], :page => params[:page], :per_page => 25, :with => { :user_id => current_user.id }, :order => 'updated_at DESC'
      render :partial => "clippings", :layout => false, :locals => { :clippings => @clippings, :has_updated => @has_updated = true }
    else # search
      @clippings = Clipping.search params[:search], :page => params[:page], :per_page => 25, :with => { :user_id => current_user.id }, :order => 'updated_at DESC'
    end
    # respond_to do |format|  
    #   #format.html # list.html.erb
    #   format.json  { render :json => @clippings }
    #   format.xml  { render :xml => @clippings }
    # end
  end

  def new
    @clipping = Clipping.new(:user_id => current_user.id)
  end

  def show
    @clipping = Clipping.find_by_id(params[:id])
    if @clipping.nil?
      flash[:notice] = "That clipping does not exist."
      redirect_to(:action => 'list')
      return false
    end
    following = Following.where("user_id=:user_id AND follow_id=:follow_id", {:user_id => current_user.id, :follow_id => @clipping.user.id}).first
    if @clipping.user_id == current_user.id
      return @clipping
    elsif @clipping.public and following
      return @clipping
    else
      @clipping = nil
      flash[:notice] = "That clipping does not exist."
      redirect_to(:action => 'list')
    end
  end

  def stream
    followings = Following.where("user_id=:user_id", {:user_id => current_user.id})
    following_ids = Array.new
    followings.each {|following| following_ids << following.follow_id}
    @clippings = Clipping.paginate(:page => params[:page], :per_page => 25, :conditions => ["public=1 and user_id IN (?)", following_ids], :order => 'updated_at DESC')
  end

  def update
    @clipping = Clipping.find_by_id(params[:id])
    if @clipping.nil?
      flash[:notice] = "That clipping does not exist."
      redirect_to(:action => 'list')
      return false
    end
    if @clipping.user_id == current_user.id
      @clipping.title = params[:title]
      @clipping.summary = params[:summary]
      if @clipping.stored_clipping.nil?
        @stored_clipping = StoredClipping.new
        @stored_clipping.content = ""
        @clipping.stored_clipping = @stored_clipping
      end
      if "text" === @clipping.content_type
        @clipping.stored_clipping.content = params[:content]
      else
        if @clipping.url != params[:url]
          @clipping.url = params[:url]
          @clipping.retrieve_html_content
          @clipping.title = @clipping.retrieve_title_from_html
          @clipping.stored_clipping.content = @clipping.retrieve_body_from_html
        end
      end
      @clipping.public = params[:public]
      @clipping.favorite = params[:favorite]
      @clipping.read = params[:read]
      @clipping.archive = params[:archive]
      if @clipping.save
        flash[:notice] = "Clipping Updated"
        redirect_to(:action => 'show', :id => @clipping.id)
      else
        render('edit')
      end
    else
      @clipping = nil
      flash[:notice] = "That clipping does not exist."
      redirect_to(:action => 'list')
    end
  end

  private

end