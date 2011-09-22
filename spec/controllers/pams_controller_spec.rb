require 'spec_helper'

describe PamsController do

  render_views
  
  before(:each) do
    @quality = Factory(:quality)
    @pam = Pam.find(:first, :conditions => ["quality_id = ? and grade = ?", @quality.id, "A"])
  end
  
  describe "for non-signed_in users" do
    
    describe "GET 'edit'" do
      it "should not be successful" do
        get :edit, :id => @pam.id
        response.should_not be_success
      end
    end
  
  end
  
  describe "for signed-in non-admins" do
  
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    it "should ?not display the 'edit' form"
  end
  
  
  describe "for signed-in admins" do
  
    before(:each) do
      @admin = Factory(:user, :admin => true)
      test_sign_in(@admin)
    end
    
    describe "GET 'edit'" do
      
      it "should be successful" do
        get :edit, :id => @pam.id
        response.should be_success
      end
      
      it "should refer to the correct attribute" do
        get :edit, :id => @pam.id
        response.should have_selector(".display_text", :content => "Attribute: #{@quality.quality}")
      end
      
      it "should mention the correct grade" do
        get :edit, :id => @pam.id
        response.should have_selector(".label_large", :content => "Edit PAM: Grade #{@pam.grade}")
      end
      
      it "should have a textarea containing the descriptor" do
        get :edit, :id => @pam.id
        response.should have_selector("textarea", :id => "pam_descriptor")
      end
      
      it "should have a 'Confirm' button" do
        get :edit, :id => @pam.id
        response.should have_selector("input", 
                    :type => "submit", 
                    :value => "Confirm changes")
      end
      
      it "should have a link to return to the attribute_submission 'show' page" do
        get :edit, :id => @pam.id
        response.should have_selector("a", :href => attribute_submission_path(@pam.quality_id),
        			:content => "Cancel")
      end
      
      it "should display the other PAMs for the attribute" do
        @quality = Quality.find(@pam.quality_id)
        @pams = @quality.pams.all
        get :edit, :id => @pam.id
        @pams.each do |pam|
          response.should have_selector("td", :content => pam.descriptor)
        end
      end
      
      describe "for approved attributes" do
        
        before(:each) do
          @approved_quality = Factory(:quality, :quality => "Approved Attr",
          	:approved => true)
          @approved_pam = Pam.where("quality_id = ? and grade = ?", @approved_quality.id, "A")
        end
        
        it "should have a link to return to the attribute 'show' page" do
          get :edit, :id => @approved_pam
          response.should have_selector("a", :href => quality_path(@approved_quality.id),
        			:content => "Cancel")
        end
      end
      
      describe "for rejected attributes" do
      
        before(:each) do
          @rejected_quality = Factory(:quality, :quality => "Rejected",
          	:approved => false, :removed => true, :removal_date => Date.today)
          @rejected_pam = Pam.where("quality_id = ? and grade = ?", @rejected_quality.id, "A")
        end
        
        it "should have a link to return to the attribute_submission 'show' page" do
          get :edit, :id => @rejected_pam
          response.should have_selector("a", :href => attribute_submission_path(@rejected_quality.id),
        			:content => "Cancel")
        end
      end
      
    end
    
    describe "PUT 'update'" do
    
      describe "failure" do
      
        before(:each) do
          @attr = { :descriptor => "" }
        end
        
        it "should not change the PAM attributes" do
          put :update, :id => @pam, :pam => @attr
          @pam.reload
          @pam.descriptor.should_not  == ""
        end
        
        it "should have the right title" do
          put :update, :id => @pam, :pam => @attr
          response.should have_selector("title", :content => "Edit PAM")
        end
        
        it "should re-present the 'edit' page" do
          put :update, :id => @pam, :pam => @attr
          response.should render_template('edit')
        end
        
      end
      
      describe "success" do
        
        before(:each) do
          @attr = { :descriptor => "A proper descriptor", 
                    :updated_by => @admin.id }
        end
        
        it "should not change the number of PAMs" do
          lambda do
            put :update, :id => @pam, :pam => @attr
          end.should_not change(Pam, :count)
        end

        it "should change the quality's attributes" do
          put :update, :id => @pam, :pam => @attr
          @pam.reload
          @pam.descriptor.should  == @attr[:descriptor]
        end
            
        it "should save the current user as the last updater" do
          put :update, :id => @pam, :pam => @attr
          @pam.reload
          @pam.updated_by.should  == @admin.id
        end

        it "should redirect to the attribute_submissions show page" do
          put :update, :id => @pam, :pam => @attr
          response.should redirect_to attribute_submission_path(@pam.quality_id)
        end

        it "should have a flash message" do
          put :update, :id => @pam, :pam => @attr
          flash[:success].should == "Grade #{@pam.grade} updated."
        end
        
        describe "for approved attributes" do
          
          before(:each) do
            @approved_quality = Factory(:quality, :quality => "Approved",
          	:approved => true)
            @approved_pam = Pam.where("quality_id = ? and grade = ?", @approved_quality.id, "A")
          end
          
          it "should redirect to the attribute show page" do
            put :update, :id => @approved_pam, :pam => @attr
            response.should redirect_to quality_path(@approved_quality.id)
          end

        end
        
        describe "for rejected attributes" do
        
          before(:each) do
            @rejected_quality = Factory(:quality, :quality => "Rejected",
          	:approved => false, :removed => true, :removal_date => Date.today)
            @rejected_pam = Pam.where("quality_id = ? and grade = ?", @rejected_quality.id, "A")
          end
          
          it "should redirect to the attribute_submissions show page" do
            put :update, :id => @rejected_pam, :pam => @attr
            response.should redirect_to attribute_submission_path(@rejected_quality.id)
          end
          
        end
      
      end
    
    end

  end
end
