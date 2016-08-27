class UsersController < ApplicationController
	before_filter :user_exist, only: [:new]

	def index
		@time = Time.now
	end

	def new
	  @user = User.new
	end

	def create
	  @user = User.new(users_params)
	  if @user.save
	  	cookies[:auth_token] = @user.auth_token
	    redirect_to root_url, :notice => "Thank you for signing up!"
	  else
	    render "new"
	  end
	end

	private

	def users_params
		params.require(:user).permit(:email, :password, :password_confirmation)
	end
end
