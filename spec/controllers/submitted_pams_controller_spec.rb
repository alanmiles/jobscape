require 'spec_helper'

describe SubmittedPamsController do

  render_views
  
  before(:each) do
    @user = Factory(:user)
    @user2 = Factory(:user, :email => "user2@example.com")
    @admin = Factory(:user, :email => "admin@example.com", :admin => true)
    @approved_quality = Factory(:quality, :approved => true)
    @removed_quality = Factory(:quality, :quality => "Removed", 
                                :removed => true, :created_by => @user.id)
    @unseen_quality = Factory(:quality, :quality => "Unseen",
                                :created_by => @user.id)
    @other_user_quality = Factory(:quality, :quality => "Other user", 
                                :created_by => @user2.id)
    @admin_quality = Factory(:quality, :quality => "Admin",
                                :created_by => @admin.id)

    @approved_pam = Pam.find(:first, 
            :conditions => ["quality_id = ? and grade = ?", @approved_quality.id, "A"])
    @removed_pam = Pam.find(:first, 
            :conditions => ["quality_id = ? and grade = ?", @removed_quality.id, "A"])
    @unseen_pam = Pam.find(:first, 
            :conditions => ["quality_id = ? and grade = ?", @unseen_quality.id, "A"])
    @other_user_pam = Pam.find(:first, 
            :conditions => ["quality_id = ? and grade = ?", @other_user_quality.id, "A"])
    @admin_pam = Pam.find(:first, 
            :conditions => ["quality_id = ? and grade = ?", @admin_quality.id, "A"])        
                                 
  end
  
  describe "for non-signed_in users" do
    
    describe "GET 'edit'" do
      it "should not be successful" do
        get :edit, :id => @unseen_pam
        response.should_not be_success
      end
    end
  
  end
  
  describe "for signed-in admins" do
  
    before(:each) do
      test_sign_in(@admin)
    end
    
    describe "GET 'edit'" do
      it "should not be successful" do
        get :edit, :id => @admin_pam
        response.should_not be_success
      end
    end
  end
  
  
  describe "for signed-in non-admins" do
  
    before(:each) do
      test_sign_in(@user)
    end
    
    describe "GET 'edit'" do
    
      describe "for previously approved qualities" do
    
        it "should not be successful" do
          get :edit, :id => @approved_pam.id
          response.should_not be_success
        end
    
      end
    
      describe "for rejected qualities" do
    
        it "should not be successful" do
          get :edit, :id => @removed_pam.id
          response.should_not be_success
        end
        
      end
    
      describe "for qualities created by another user" do
    
        it "should not be successful" do
          get :edit, :id => @other_user_pam.id
          response.should_not be_success
        end
    
      end
    
      describe "for unapproved submissions from current user" do
    
        it "should be successful" do
          get :edit, :id => @unseen_pam.id
          response.should be_success
        end
      
        it "should refer to the correct attribute" do
          get :edit, :id => @unseen_pam.id
          response.should have_selector(".display_text", :content => "Attribute: #{@unseen_quality.quality}")
        end
      
        it "should mention the correct grade" do
          get :edit, :id => @unseen_pam.id
          response.should have_selector(".label_large", :content => "Edit PAM: Grade #{@unseen_pam.grade}")
        end
      
        it "should have a textarea containing the descriptor" do
          get :edit, :id => @unseen_pam.id
          response.should have_selector("textarea", :id => "pam_descriptor")
        end
      
        it "should have a 'Confirm' button" do
          get :edit, :id => @unseen_pam.id
          response.should have_selector("input", 
                    :type => "submit", 
                    :value => "Confirm changes")
        end
      
        it "should have a link to return to the attribute 'show' page" do
          get :edit, :id => @unseen_pam.id
          response.should have_selector("a", :href => submitted_quality_path(@unseen_pam.quality_id),
        			:content => "Cancel")
        end
      
        it "should display the other PAMs for the attribute" do
          @quality = Quality.find(@unseen_pam.quality_id)
          @pams = @quality.pams.all
          get :edit, :id => @unseen_pam.id
          @pams.each do |pam|
            response.should have_selector("td", :content => pam.descriptor)
          end
        end
      end
    end
    
    describe "PUT 'update'" do
    
      describe "for previously approved qualities" do
    
        before(:each) do
          @attr = { :descriptor => "A proper descriptor",
                    :updated_by => @user.id }
        end
        
        it "should not change the quality's attributes" do
          put :update, :id => @approved_pam, :pam => @attr
          @approved_pam.reload
          @approved_pam.descriptor.should_not  == @attr[:descriptor]
        end
                    
        it "should redirect to the root path" do
          put :update, :id => @approved_pam, :pam => @attr
          response.should redirect_to root_path
        end
        
        it "should display an explanatory message" do
          put :update, :id => @approved_pam, :pam => @attr
          flash[:notice].should =~ /an attribute that's already been approved./i
        end
    
      end
    
      describe "for rejected qualities" do
    
        before(:each) do
          @attr = { :descriptor => "A proper descriptor",
                    :updated_by => @user.id }
        end
        
        it "should not change the quality's attributes" do
          put :update, :id => @removed_pam, :pam => @attr
          @removed_pam.reload
          @removed_pam.descriptor.should_not  == @attr[:descriptor]
        end
        
      end
    
      describe "for qualities created by another user" do
    
        before(:each) do
          @attr = { :descriptor => "A proper descriptor",
                    :updated_by => @user.id }
        end
        
        it "should redirect to the root " do
          put :update, :id => @other_user_pam, :pam => @attr
          @other_user_pam.reload
          @other_user_pam.descriptor.should_not  == @attr[:descriptor]
        end
    
      end
      
      describe "for unapproved submissions from current user" do
      
        describe "failure" do
      
          before(:each) do
            @attr = { :descriptor => "",
                      :updated_by => @user.id }
          end
        
          it "should not change the PAM attributes" do
            put :update, :id => @unseen_pam, :pam => @attr
            @unseen_pam.reload
            @unseen_pam.descriptor.should_not  == ""
          end
        
          it "should have the right title" do
            put :update, :id => @unseen_pam, :pam => @attr
            response.should have_selector("title", :content => "Edit PAM submission")
          end
        
          it "should re-present the 'edit' page" do
            put :update, :id => @unseen_pam, :pam => @attr
            response.should render_template('edit')
          end
        
        end
      
      
        describe "success" do
        
          before(:each) do
            @attr = { :descriptor => "A proper descriptor", 
                    :updated_by => @user.id }
          end
        
          it "should not change the number of PAMs" do
            lambda do
              put :update, :id => @unseen_pam, :pam => @attr
            end.should_not change(Pam, :count)
          end

          it "should change the quality's attributes" do
            put :update, :id => @unseen_pam, :pam => @attr
            @unseen_pam.reload
            @unseen_pam.descriptor.should  == @attr[:descriptor]
          end
         
          it "should save the current user as the last updater" do
            put :update, :id => @unseen_pam, :pam => @attr
            @unseen_pam.reload
            @unseen_pam.updated_by.should  == @user.id
          end

          it "should redirect to the submitted quality show page" do
            put :update, :id => @unseen_pam, :pam => @attr
            response.should redirect_to submitted_quality_path(@unseen_pam.quality_id)
          end

          it "should have a flash message" do
            put :update, :id => @unseen_pam, :pam => @attr
            flash[:success].should == "Grade #{@unseen_pam.grade} updated."
          end
        end
      end
    
    end

  end

end
