class ClearanceQueuesController < ApplicationController

  def index
    @cqueue = ClearanceQueue.all.order('created_at desc')
  end
 
  def new
    @cqueue = ClearanceQueue.new
  end
 
  def create
    @cqueue = ClearanceQueue.new(cqueue_params)
     potential_item_id = @cqueue.scanned_item
     
    if potential_item_id.blank? || potential_item_id == 0 || !potential_item_id.is_a?(Integer)
      flash[:danger] = "Item id #{potential_item_id} is not valid"  
    elsif ClearanceQueue.exists?(:scanned_item => potential_item_id)
      flash[:danger] = "Item id #{potential_item_id} already exists"
    elsif Item.where(id: potential_item_id).none?
      flash[:danger] = "Item id #{potential_item_id} could not be found"      
    elsif Item.sellable.where(id: potential_item_id).none?
      flash[:danger] = "Item id #{potential_item_id} could not be clearanced"
    else
      @cqueue = ClearanceQueue.create(cqueue_params)
      flash[:success] = "Your item was added to the batch successfully!"
    end
    redirect_to '/clearance_queues/new'
  end

  def process(cqueue)
    if not cqueue.empty?
      ClearancingService.new.process_items_to_batch(cqueue)
      flash[:success] = "Batch was created"
    else
      flash[:alert] = "Nothing found"
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
