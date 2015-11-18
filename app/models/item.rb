class Item < ActiveRecord::Base

  CLEARANCE_PRICE_PERCENTAGE  = BigDecimal.new("0.75")

  belongs_to :style
  belongs_to :clearance_batch

  scope :sellable, -> { where(status: 'sellable') }

  def clearance!
    
    minprice = style.wholesale_price
    
    if minprice < 6.6666 && style.type == "Pants" || minprice < 6.6666 && style.type == "Dress"
        minprice = 6.6666
    elsif minprice < 2.6666
      minprice = 2.6666
    end 
    
    update_attributes!(status: 'clearanced', 
                       price_sold: minprice * CLEARANCE_PRICE_PERCENTAGE)
  end

end
