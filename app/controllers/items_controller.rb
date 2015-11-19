class ItemsController < ApplicationController
  
  def index
    @items = Item.paginate(:page => params[:page], :per_page => 10).order('status ASC')
  end
  
  def index_batches
    @itemsbybatch = Item.where.not(:clearance_batch_id => nil).order('clearance_batch_id asc')
  end

end
