class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers]


  def index
    @users = User.all.page(params[:page])
    # @q = User.ransack(params[:q])
    # @users = @q.result(distinct: :true).page(params[:page]).per(9)
  end
  
  def show
    @user = User.find(params[:id])
    @items = @user.items.uniq
    @count_have = @user.have_items.count
    @count_want = @user.want_items.count
    @count_followings = @user.followings.count
    @count_followers = @user.followers.count
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = 'ユーザーを登録しました'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザーの登録に失敗しました'
      render :new
    end
  end

  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end

  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
