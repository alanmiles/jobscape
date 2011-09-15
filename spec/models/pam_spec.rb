# == Schema Information
#
# Table name: pams
#
#  id         :integer         not null, primary key
#  quality_id :integer
#  grade      :string(255)
#  descriptor :string(255)
#  updated_by :integer
#  approved   :boolean         default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Pam do

  before(:each) do
    @quality = Factory(:quality)
    @attr = { :descriptor => "Measurement", :grade => "A" }
    @dup_attr = { :grade => "B", :descriptor => "Measurement" }
  end
  
  it "should have created a PAM as the Quality was created" do
    #@quality.pams.create!(@attr)
    @pam = Pam.find(:first, :conditions => ["quality_id = ?", @quality.id])
    @pam.should be_valid
  end
  
  describe "associations" do
  
    before(:each) do
      @pam = @quality.pams.create(@attr)
    end
    
    it "should have a quality attribute" do
      @pam.should respond_to(:quality)
    end
  
    it "should be associated with the correct quality" do
      @pam.quality_id.should == @quality.id
      @pam.quality.should == @quality
    end
  end
  
  describe "validations" do
  
    it "should not accept an empty grade" do
      no_grade = @quality.pams.new(@attr.merge(:grade => ""))
      no_grade.should_not be_valid
    end
    
    it "should not accept a long grade" do
      long_grade = "AB"
      long_grade_pam = @quality.pams.new(@attr.merge(:grade => long_grade))
      long_grade_pam.should_not be_valid
    end
    
    it "should not accept a lower-case grade" do
      lowcase_grade = "a"
      lowcase_grade_pam = @quality.pams.new(@attr.merge(:grade => lowcase_grade))
      lowcase_grade_pam.should_not be_valid
    end
    
    it "should not accept an empty descriptor" do
      no_descriptor = @quality.pams.new(@attr.merge(:descriptor => ""))
      no_descriptor.should_not be_valid
    end
    
    it "should not accept a long descriptor" do
      long_descriptor = "a" * 256
      long_descriptor_pam = @quality.pams.new(@attr.merge(:descriptor => long_descriptor))
      long_descriptor_pam.should_not be_valid
    end
    
    it "should not accept a duplicate descriptor for the same quality" do
      @quality.pams.create(@attr)
      dup_pam = @quality.pams.new(@dup_attr)
      dup_pam.should_not be_valid
    end
    
    it "can accept a duplicate descriptor for a different quality" do
      @quality2 = Factory(:quality, :quality => "Second quality")
      @pam_1 = Pam.find(:first, :conditions => ["quality_id = ? and grade = ?", @quality.id, "A"])
      @pam_2 = Pam.find(:first, :conditions => ["quality_id = ? and grade = ?", @quality2.id, "A"])
     
      @pam_2.should be_valid
      @pam_1.descriptor.should == @pam_2.descriptor
    end
    
  end
end
