class ClearanceBatchesController < ApplicationController

  def index
    @clearance_batches  = ClearanceBatch.all.order('created_at desc')
  end
  
  def upload
    @clearance_batches  = ClearanceBatch.all
  end

  def create
    if(params[:csv_batch_file])
      clearancing_status = ClearancingService.new.process_file(params[:csv_batch_file].tempfile)
      clearance_batch    = clearancing_status.clearance_batch
      alert_messages     = []
      if clearance_batch.persisted?
        flash[:notice]  = "#{clearance_batch.items.count} items clearanced in batch #{clearance_batch.id}"
      else
        alert_messages << "No new clearance batch was added"
      end
      if clearancing_status.errors.any?
        alert_messages << "#{clearancing_status.errors.count} item ids raised errors and were not clearanced"
        clearancing_status.errors.each {|error| alert_messages << error }
      end
      flash[:alert] = alert_messages.join("<br/>") if alert_messages.any?
    else
      flash[:danger] = "Please select a file"
    end    
    redirect_to action: :index
  end

  def show
    @clearance_batches  = ClearanceBatch.find(params[:id])
  end

end
