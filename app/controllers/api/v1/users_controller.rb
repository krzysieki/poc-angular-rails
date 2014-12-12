class Api::V1::UsersController < Api::V1::BaseController

  # Globally rescue Authorization Errors in controller.
  # Returning 403 Forbidden if permission is denied
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied

  # Enforces access right checks for individuals resources
  after_filter :verify_authorized, :except => :index

  # Enforces access right checks for collections
  after_filter :verify_policy_scoped, :only => :index

  def index
    @users = policy_scope(User)
    authorize User
    render :json => {:info => "Users", :users => @users}, :status => 200
  end

  def show
    authorize current_user
    render :json => {:info => "Current User", :user => current_user}, :status => 200
  end

  def create
    @user = User.create(secure_params)

    authorize @user
    if @user.valid?
      sign_in(@user)
      respond_with @user, :location => api_users_path
    else
      respond_with @user.errors, :location => api_users_path
    end
  end

  def update
    @user = User.find(params[:id])
    authorize @user

    if @user.update_attributes(secure_params)
      render :json => {:info => "Current user", :user => current_user}, :status => 200
    else
      render :json => {:errors =>  @user.errors.messages}, :status => 422
    end
  end

  def destroy
    user = User.find(current_user.id)
    authorize user
    respond_with :api, user.destroy
  end

  private

  def permission_denied
    respond_to do |format|
      format.json { render :json => {:error => t(:access_denied)}, :status => 403 }
    end
  end

  def secure_params
    params.require(:user).permit(:role, :email, :password, :password_confirmation)
  end

end
