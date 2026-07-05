class Administration::UsersController < Administration::BaseController
  # GET /administration/users
  # GET /administration/users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @users }
    end
  end

  # GET /administration/users/1
  # GET /administration/users/1.json
  def show
    ### Retrieved by Callback function

    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  # GET /administration/users/new
  # GET /administration/users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  # POST /administration/users
  # POST /administration/users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: t(".Success") } # 'User was successfully created.'
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
end
