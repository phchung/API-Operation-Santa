class Api::UserController < ApplicationController

  def create
    @user = User.create(user_params)
    if @user.save
      if !family_params["family_photo"].nil?
        cloudinary_return = Cloudinary::Uploader.upload('data:image/png\;base64,' + params["family_photo"])
        photo_url = {family_photo: cloudinary_return["url"]}
        @family = Family.create(family_params.merge({user_id: @user.id}).merge(photo_url))
      elsif params["account_type"] == "donor"

      end
      login(@user)
      @session = true
      render "api/users/show"
    else
      render json: @user.errors, status: 401
    end
  end

  def index
    if params["account_type"] == "family"
      @users = User.all.where(:account_type => "family")
    elsif params["account_type"] == "donor"
      @users = User.all.where(:account_type => "donor")
    else
      @users = User.all
    end
    render "api/users/index"
  end

# GET /api/users/:userid
  def show
    @user = User.find(params[:id])
    if @user
      render "api/users/show"
    else
      render json:@user.errors, status: 204
    end
  end

# PUT /api/users/:userid
  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    render "api/users/show"
  end

# DELETE /api/users/:userid
  def destroy
    @user = User.find(params[:id])
    if @user
      @user.destroy
      render json:{"status"=>"user been deleted"},status: 200
    else
      render json: @user.errors, status: 401
    end
  end

private

  def user_params
    params.permit(
      :username,:password,:first_name,:last_name,:phone_number,:account_type,:address
    )
  end

  def family_params
    params.permit(
      :description,:family_size,:family_photo,:family_story
    )
  end
end
