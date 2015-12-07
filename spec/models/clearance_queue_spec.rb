require 'spec_helper'
require 'capybara/rspec'

RSpec.describe ClearanceQueue, type: :feature do

  describe "success adding an item to clearance queue" do
    
    it "should add a new item to the queue that can be clearanced" do
      @newitem = '123'
      FactoryGirl.create(:item, id: @newitem, status: 'sellable')
      visit "/clearance_queues/new"
      fill_in 'clearance_queue[scanned_item]', :with => @newitem
      click_button 'Add'
      @item = Item.find(@newitem)
      expect(@item.status).to eq("sellable")
      ClearanceQueue.delete_all
      @cqueue = ClearanceQueue.create(scanned_item: @newitem)
      expect(ClearanceQueue.all.count).to eq(1)
      expect(page).to have_content "Item #{@newitem} was added to the batch successfully!"
    end
      
    it "should add a second item that can be clearanced" do
      @newitem = '234'
      FactoryGirl.create(:item, id: @newitem, status: 'sellable')
      visit "/clearance_queues/new"
      fill_in 'clearance_queue[scanned_item]', :with => @newitem
      click_button 'Add'
      @item = Item.find(@newitem)
      expect(@item.status).to eq("sellable")
      @cqueue = ClearanceQueue.create!(scanned_item: @newitem)
      expect(ClearanceQueue.all.count).to eq(2)
      expect(page).to have_content "Item #{@newitem} was added to the batch successfully!"
    end
   
  end
  
  describe "exceptions adding an item to clearance queue" do
    
    
   it "item is not valid" do
      @newitem = 'ABC'
      visit "/clearance_queues/new"
      fill_in 'clearance_queue[scanned_item]', :with => @newitem
      click_button 'Add'
      expect(page).to have_content "Item 0 is not valid" 
    end
    
    it "item was already clearanced and should not added to clearance queue" do
      @newitem = '555'
      FactoryGirl.create(:item, id: @newitem, status: 'clearanced')
      visit "/clearance_queues/new"
      fill_in 'clearance_queue[scanned_item]', :with => @newitem
      click_button 'Add'
      @item = Item.find(@newitem)
      expect(@item.status).to eq("clearanced")
      expect(ClearanceQueue.all.count).to eq(0)
      expect(page).to have_content "Item #{@newitem} could not be clearanced"
      
    end
    
    it "item that is already in the clearance queue" do
      @newitem = '666'
      FactoryGirl.create(:item, id: @newitem, status: 'sellable')
      ClearanceQueue.create!(scanned_item: @newitem)
      visit "/clearance_queues/new"
      fill_in 'clearance_queue[scanned_item]', :with => @newitem
      click_button 'Add'
      @item = Item.find(@newitem)
      expect(@item.status).to eq("sellable")
      expect(ClearanceQueue.find_by_id(@newitem)).present?
      expect(page).to have_content "Item #{@newitem} already exists"     
    end
  
  end
  
  describe "processing of the clearance queue" do
    
    it "removing an item from the clearance queue before processing" do
      @newitem = '123'
      FactoryGirl.create(:item, id: @newitem, status: 'sellable')
      @clearance_queue = ClearanceQueue.create!(scanned_item: @newitem)
      visit "/clearance_queues/"
      click_link "Delete"
      expect(page).to have_content "Item Deleted"
    end
  
    it "processing items in the clearance queue" do 
      @newitem = '123'
      FactoryGirl.create(:item, id: @newitem, status: 'sellable')
      @clearance_queue = ClearanceQueue.create!(scanned_item: @newitem) 
      @newitem = '124'
      FactoryGirl.create(:item, id: @newitem, status: 'sellable')
      @clearance_queue = ClearanceQueue.create!(scanned_item: @newitem) 
      @newitem = '125'
      FactoryGirl.create(:item, id: @newitem, status: 'sellable')
      @clearance_queue = ClearanceQueue.create!(scanned_item: @newitem) 
      visit "/clearance_queues/"
      expect(ClearanceQueue.all.count).to eq(3)
      click_button "Process Batch"
      expect(ClearanceQueue.all.count).to eq(0)
      expect(page).to have_content "Batch was created sucessfully"
    end
     
    it "no items exist in the clearance queue" do 
      visit "/clearance_queues/"
      click_button "Process Batch"
      expect(page).to have_content "No records were found"
    end
   
  end

  
end
