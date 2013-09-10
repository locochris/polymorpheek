require_relative '../models'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

describe "polymorphic parent associations from an STI table" do
  let(:father) { Father.create!(name: 'Mike') }
  let(:mother) { Mother.create!(name: 'Carol') }
  let(:boy_names) { %w(Greg Peter Bobby) }
  let(:girl_names) { %w(Marcia Jan Cindy) }

  before do
    DatabaseCleaner.clean

    boy_names.each do |child_name|
      father.children.create!(name: child_name, type: 'Boy')
    end

    girl_names.each do |child_name|
      mother.children.create!(name: child_name, type: 'Girl')
    end
  end

  it "father should have 3 boys named: greg, peter & bobby" do
    father.children.count.should eql 3
    father.children.where(true).to_a { |child| child.should be_a Boy }
    father.children.map(&:name).should eql boy_names
  end

  it "mother should have 3 girls named: marcia, jan & cindy" do
    mother.children.count.should eql 3
    mother.children.where(true).to_a { |child| child.should be_a Girl }
    mother.children.map(&:name).should eql girl_names
  end

  it "mother + father should have 6 children" do
    (mother.children + father.children).count.should eql 6
  end

  it "there should be 3 boys" do
    Boy.count.should eql 3
    Boy.where(true).to_a { |child| child.is_a? Boy }
  end

  it "there should be 3 girls" do
    Girl.count.should eql 3
    Girl.where(true).to_a { |child| child.is_a? Girl }
  end

  it "there should be 6 children" do
    Child.count.should eql 6
  end
end
