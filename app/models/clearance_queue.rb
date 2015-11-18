class ClearanceQueue < ActiveRecord::Base
  belongs_to :item, foreign_key: 'scanned_item'
end
