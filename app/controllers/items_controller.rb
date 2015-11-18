class ItemsController < ApplicationController
  
  def index
    @items = Item.all.order('status asc')
  end
  
  def index_batches
    @itemsbybatch = Item.where.not(:clearance_batch_id => nil).order('clearance_batch_id asc')
  end

end
