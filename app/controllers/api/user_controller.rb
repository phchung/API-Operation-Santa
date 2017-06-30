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

      @session_token = generate_token(@user.email)
      login(@user.id)

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
    if @user.update(user_updatable_params)
      if family_params.present?
        family_relation = @user.family_data
        if family_relation
          family_relation.update_attributes(family_params)
        else
          photo_url = {}
          if !family_params["family_photo"].nil?
            cloudinary_return = Cloudinary::Uploader.upload('data:image/png\;base64,' + params["family_photo"])
            photo_url = {family_photo: cloudinary_return["url"]}
          else
            @family = Family.create(family_params.merge({user_id: @user.id}).merge(photo_url))
          end
        end
      end
      render "api/users/show"
    else
      render json:@user.errors.full_messages, stats:204
    end
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
      :username,:password,:first_name,:last_name,:phone_number,:account_type,:address,:email
    )
  end

  def user_updatable_params
    params.permit(
      :username,:password,:first_name,:last_name,:phone_number,:address,:email
    )
  end

  def family_params
    params.permit(
      :description,:family_size,:family_photo,:family_story,:wish_list
    )
  end
end
