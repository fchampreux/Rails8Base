class Administration::UsersController < Administration::BaseController
  # Only DB-indexed columns (or index-backed combinations) are offered as sort keys,
  # so ordering stays index-backed.
  SORT_COLUMNS = {
    "code"      => %i[ code ],
    "is_active" => %i[ is_active ],
    "owner_id"  => %i[ owner_id ],
    "name"      => %i[ last_name first_name ]
  }.freeze

  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /administration/users
  def index
    scope  = User.includes(:owner, :main_group)
    scope  = scope.search(params[:q]) if params[:q].present?
    scope  = scope.order(sort_columns.index_with { sort_direction })
    @pagy, @users = pagy(scope)
  end

  # GET /administration/users/1
  def show
  end

  # GET /administration/users/new
  def new
    @user = User.new
  end

  # GET /administration/users/1/edit
  def edit
  end

  # POST /administration/users
  def create
    @user = User.new(user_params)
    @user.owner_id      = current_user.id
    @user.created_by_id = current_user.id
    @user.updated_by_id = current_user.id

    if @user.save
      redirect_to administration_user_path(@user), notice: t(".Success")
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /administration/users/1
  def update
    @user.updated_by_id = current_user.id

    if @user.update(user_params)
      redirect_to administration_user_path(@user), notice: t(".Success"), status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /administration/users/1
  # Nothing is ever hard-deleted (see app/models/CLAUDE.md) — deactivate instead.
  def destroy
    @user.updated_by_id = current_user.id
    @user.update!(is_active: false)
    redirect_to administration_users_path, notice: t(".Success"), status: :see_other
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def sort_columns
    SORT_COLUMNS[params[:sort]] || SORT_COLUMNS["code"]
  end

  def sort_direction
    params[:direction] == "desc" ? :desc : :asc
  end

  def user_params
    params.require(:user).permit(:code, :first_name, :last_name, :email, :is_active, :is_admin, :password, :password_confirmation)
  end
end
