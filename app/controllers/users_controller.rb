class UsersController < ApplicationController

  before_action :ensure_correct_user, only: [:update]

  def show
    @user = User.find(params[:id])
    @books = @user.books.includes(:favorited_users).sort {|a,b| b.favorited_users.includes(:favorites).where(created_at: Time.current.all_week).size <=> a.favorited_users.includes(:favorites).where(created_at: Time.current.all_week).size}
    # @books = Book.includes(:favorited_users).sort {|a,b| b.favorited_users.includes(:favorites).where(created_at: Time.current.all_week).size <=> a.favorited_users.includes(:favorites).where(created_at: Time.current.all_week).size}

    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])

      if @user.id == current_user.id
        render :edit
      else
        redirect_to user_path(current_user)
      end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path(@user.id)
    else
      render "edit"
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

end
