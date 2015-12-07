class ClearanceQueuesController < ApplicationController

  def index
    @clearance_queue = ClearanceQueue.all.order('created_at desc')
  end
 
  def new
    @clearance_queue = ClearanceQueue.new
  end
 
  def create
     @clearance_queue = ClearanceQueue.new(cqueue_params)
     potential_item_id = @clearance_queue.scanned_item
     
    if potential_item_id.blank? || potential_item_id == 0 || !potential_item_id.is_a?(Integer)
      flash[:danger] = "Item #{potential_item_id} is not valid"  
    elsif ClearanceQueue.exists?(:scanned_item => potential_item_id)
      flash[:danger] = "Item #{potential_item_id} already exists"
    elsif Item.where(id: potential_item_id).none?
      flash[:danger] = "Item #{potential_item_id} could not be found"      
    elsif Item.sellable.where(id: potential_item_id).none?
      flash[:danger] = "Item #{potential_item_id} could not be clearanced"
    else
      @clearance_queue.save
      flash[:success] = "Item #{potential_item_id} was added to the batch successfully!"
    end
    redirect_to '/clearance_queues/new'
  end

  def processscanned
    @clearance_queue = ClearanceQueue.all
    if not @clearance_queue.empty?
      ClearancingService.new.process_items_to_batch(@clearance_queue)
      flash[:success] = "Batch was created sucessfully"
      redirect_to '/clearance_batches/'
    else
      flash[:danger] = "No records were found"
      redirect_to '/clearance_queues/'
    end

  end
  
  def destroy
    ClearanceQueue.find(params[:id]).destroy
    flash[:success] = "Item Deleted"
    redirect_to clearance_queues_path
  end

private

  def cqueue_params
    params.require(:clearance_queue).permit(:scanned_item)
  end
  
end
