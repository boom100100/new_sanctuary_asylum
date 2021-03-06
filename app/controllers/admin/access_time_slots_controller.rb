class Admin::AccessTimeSlotsController < AdminController
  before_action :require_admin

  def index
    @access_time_slots = current_community.access_time_slots
  end

  def new
    @access_time_slot_type = params[:type]
    @access_time_slot = AccessTimeSlot.new
  end

  def create
    @access_time_slot = AccessTimeSlot.new(access_time_slots_params)
    if access_time_slot.save
      redirect_to community_admin_access_time_slots_path
    else
      @access_time_slot_type = params[:type]
      render :new
    end
  end

  def edit
    @access_time_slot_type = access_time_slot.grantee.role
    access_time_slot
  end

  def update
    if access_time_slot.update(access_time_slots_params)
      redirect_to community_admin_access_time_slots_path
    else
      @access_time_slot_type = params[:type]
      render :edit
    end
  end

  def destroy
    if access_time_slot.destroy
      flash[:success] = 'Access time slot successfully deleted.'
    else
      flash[:error] = 'There was an issue deleting the access time slot.'
    end
    redirect_to community_admin_access_time_slots_path
  end

  private

  def access_time_slot
    @access_time_slot ||= AccessTimeSlot.find(params[:id])
  end

  def access_time_slots_params
    params.require(:access_time_slot).permit(
      :start_time,
      :end_time,
      :use,
      :grantor_id,
      :grantee_id,
    ).merge(community_id: current_community.id)
  end
end
