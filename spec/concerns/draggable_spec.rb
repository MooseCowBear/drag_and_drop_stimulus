require 'spec_helper'

RSpec.shared_examples_for "draggable" do
  let(:model) { described_class }

  describe "validation" do
    it "is invalid without a position" do
      draggable_object = build(model.to_s.underscore.to_sym, position: nil)
      expect(draggable_object.valid?).to be(false)
    end
  end

  describe ".order_by_position" do
    it "orders draggable objects by ascending position" do
      draggable_object1 = create(model.to_s.underscore.to_sym, position: 2) 
      draggable_object2 = create(model.to_s.underscore.to_sym, position: 1) 
      res = model.order_by_position
      expect(res.first).to eq(draggable_object2)
      expect(res.last).to eq(draggable_object1)
    end
  end

  describe ".new_with_position" do
    it "assigns a new task's position to be one more than the existing max position when existing postion" do
      draggable_object = create(model.to_s.underscore.to_sym)
      new_draggable_object = model.new_with_position({})
      expect(new_draggable_object.position).to eq(1)
    end

    it "assigns a new task's position to 0 when there are no tasks yet" do
      draggable_object = model.new_with_position({})
      expect(draggable_object.position).to eq(0)
    end
  end

  describe ".update_positions" do
    before(:each) do
      @dragged_object = create(model.to_s.underscore.to_sym, position: 0)
      @other_object = create(model.to_s.underscore.to_sym, position: 1) 
      @test_params = { id: @dragged_object.id, position: 1 }
    end

    it "calls update_other_positions" do
      expect(model).to receive(:update_other_positions).with(0, 1)
      model.update_positions(@test_params[:id], @test_params[:position])   
    end

    it "updates position of dragged object" do
      allow(model).to receive(:update_other_positions)
      model.update_positions(@test_params[:id], @test_params[:position])   
      @dragged_object.reload
      expect(@dragged_object.position).to eq(1)
    end
  end

  describe ".update_other_positions" do
    it "calls update_position for each record in range" do
      allow(model).to receive(:offset).and_return(1)
      allow(model).to receive(:records_by_positions).and_return([double(), double()])
      expect(model).to receive(:update_position).twice 
      model.update_other_positions(2, 0)
    end
  end

  describe ".update_position" do
    it "updates record's position by adding offset" do
      draggable_object = create(model.to_s.underscore.to_sym, position: 0)
      model.update_position(draggable_object, 1) 
      draggable_object.reload
      expect(draggable_object.position).to eq(1)
    end
  end

  describe ".records_by_positions" do
    it "returns the records with position in range" do
      draggable_object1 = create(model.to_s.underscore.to_sym, position: 2) 
      draggable_object2 = create(model.to_s.underscore.to_sym, position: 1)
      res = model.records_by_positions(2..2)
      expect(res.include?(draggable_object1)).to be(true)
    end

    it "does not return records with positions not in range" do
      draggable_object1 = create(model.to_s.underscore.to_sym, position: 2) 
      draggable_object2 = create(model.to_s.underscore.to_sym, position: 1)
      res = model.records_by_positions(1..1)
      expect(res.include?(draggable_object1)).to be(false)
    end
  end

  describe ".offset" do
    context "when start position is less than end position" do
      it "returns -1" do
        expect(model.offset(0, 2)).to eq(-1)
      end
    end

    context "when start position is greater than end position" do
      it "returns 1" do
        expect(model.offset(2, 0)).to eq(1)
      end
    end
  end

  describe ".positions" do
    context "when start position is less than end position" do
      it "returns inclusive range of start position + 1 to end position" do
        res = model.positions(0, 2)
        expect(res).to eq(1..2)
      end
    end

    context "when start position is greater than end position" do
      it "returns inclusive range of end position to start position - 1" do
        res = model.positions(2, 0)
        expect(res).to eq(0..1)
      end
    end
  end
end