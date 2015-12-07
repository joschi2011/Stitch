require 'rails_helper'

describe Item do
  describe "#perform_clearance!" do

    let(:wholesale_price) { 100 }
    let(:item) { FactoryGirl.create(:item, style: FactoryGirl.create(:style, wholesale_price: wholesale_price)) }
    before do
      item.clearance!
      item.reload
    end

    it "should mark the item status as clearanced" do
      expect(item.status).to eq("clearanced")
    end
    
    it "should set the price_sold as 75% of the wholesale_price if above the minimum" do
      expect(item.price_sold).to eq(BigDecimal.new(wholesale_price) * BigDecimal.new("0.75"))
    end

    it "should set the minimum price_sold to $2 if not pants or dresses" do
      @item = FactoryGirl.create(:item, style: FactoryGirl.create(:style, type: "Scarf", wholesale_price: 2.22)) 
      @item.clearance!
      @item.reload
      expect(@item.style.type).not_to eq("Dress" || "Pants")
      expect(@item.price_sold.round).to eq(2)
    end
    
    it "should set the minimum price_sold to $5 for pants" do
      @item = FactoryGirl.create(:item, style: FactoryGirl.create(:style, type: "Pants", wholesale_price: 6)) 
      @item.clearance!
      @item.reload
      expect(@item.style.type).to eq("Pants")
      expect(@item.price_sold.round).to eq(5)
    end

    it "should set the minimum price_sold to $5 for dresses" do
      @item = FactoryGirl.create(:item, style: FactoryGirl.create(:style, type: "Dress", wholesale_price: 4.99)) 
      @item.clearance!
      @item.reload
      expect(@item.style.type).to eq("Dress")
      expect(@item.price_sold.round).to eq(5)
    end

  end
end
