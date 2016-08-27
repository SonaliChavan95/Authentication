class PasswordResetsController < ApplicationController
	# before_action :find_user_from_pass_token, only: [:edit, :update]
  def new
  end

  	def create
	  # user = User.find_by_email(params[:email])
	  #user.send_password_reset if user
	  #redirect_to root_url, :notice => "Email sent with password reset instructions."
	  if user = User.find_by_email(params[:email])
	  	user.send_password_reset
	  	redirect_to root_url, :notice => "Email sent with password reset instructions."
	  else 
	  	redirect_to root_url, :notice => "Email is not registered. Please check your email address and try again."
	  end
	end

	def edit
	  @user = User.find_by_password_reset_token!(params[:id])
	end

	def update
		 @user = User.find_by_password_reset_token!(params[:id])
	  if @user.password_reset_sent_at < 60.seconds.ago #> Time.now
	    redirect_to new_password_reset_path, :alert => "Password reset has expired."
	elsif @user.update_attributes(params[:user])
	  # elsif @user.update(params.require(:user).permit(:password, :password_confirmation))
	    redirect_to root_url, :notice => "Password has been reset."
	  else
	    render :edit
  	  end
	end

	private

	# def find_user_from_pass_token
	#   @user = User.find_by_password_reset_token!(params[:id])
	# end

	# def users_params
	# 	params.require(:user).permit(:email, :password, :password_confirmation)
	# end
end
