require 'spec_helper'

describe Officer::EmployeesController do

  render_views
  
  describe "GET 'edit'" do
    it "should be successful"
    #  get 'edit'
    #  response.should be_success
    #end
  end
  
  describe "PUT 'update'" do
  
    describe "when the employee placement is not cancelled" do
    
    end
    
    describe "when the employee placement is cancelled" do
    
      it "should set the 'current' attribute to false"
      it "should leave the user connected to the business, but with the 'left' attribute set to true"
      it "should deny the user access to the his/her review history in the business"
      it "should allow the user access to private diary entries"
      
      it "SHOULD DROP THE USER from the current employees list for the business"
      it "SHOULD ALLOW AN OFFICER to see the user's reviews for the past year"
      it "SHOULD ALLOW AN OFFICER to see reviews that the user has conducted"
      it "SHOULD RETAIN THE USER'S REVIEW SCORES in the aggregate scores for the department/business"
      it "SHOULD ADD THE USER to the Former Employees list"
    
      describe "when the user still has other external placements" do
      
        it "should send an email notification" 
        it "should leave the user account at 3 or 4"
           
      end
      
      describe "when the use has no other placements" do
      
        describe "when the user has an old Individual account" do
        
          it "should set the user 'account' to 1" 
          it "should email the user explaining that the account type is now 'Individual'"
          it "should permit access to any previous reviews in a private business"
        end
        
        describe "when the user has a Jobseeker or no previous account" do
          
          it "should set the user 'account' to 2"
          it "should email the user explaining that the account type is now 'Jobseeker' and how HYGWIT is still useful"
        
        end
        
      end
    
    end
    
  
  end

end
