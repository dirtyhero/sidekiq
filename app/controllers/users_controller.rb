class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.create user_params
    @user.save
    if @user.save
      redirect_to user_path @user
    else
      render "new"
    end
  end

  def show
    @user = User.find params[:id]
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    id = UserWorker.perform_at(Time.zone.now + 20.seconds, @user.id, 10)
    id = UserWorker.perform_async(@user.id, 10)
    redirect_to user_path @user
  end

  private
  def user_params
    params.require(:user).permit :name, :point
  end
end
