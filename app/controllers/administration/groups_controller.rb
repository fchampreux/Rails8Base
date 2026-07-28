class Administration::GroupsController < Administration::BaseController
  before_action :set_group, only: %i[ show edit update destroy ]

  # GET /administration/groups
  def index
    @groups = Group.all
  end

  # GET /administration/groups/1
  def show
  end

  # GET /administration/groups/new
  def new
    @group = Group.new
  end

  # GET /administration/groups/1/edit
  def edit
  end

  # POST /administration/groups
  def create
    @group = Group.new(group_params)
    @group.owner_id      = current_user.id
    @group.created_by_id = current_user.id
    @group.updated_by_id = current_user.id

    if @group.save
      redirect_to administration_group_path(@group), notice: t(".Success")
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /administration/groups/1
  def update
    @group.updated_by_id = current_user.id

    if @group.update(group_params)
      redirect_to administration_group_path(@group), notice: t(".Success"), status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /administration/groups/1
  # Nothing is ever hard-deleted (see app/models/CLAUDE.md) — deactivate instead.
  def destroy
    @group.updated_by_id = current_user.id
    @group.update!(is_active: false)
    redirect_to administration_groups_path, notice: t(".Success"), status: :see_other
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:code, :sort_code, :is_active)
  end
end
