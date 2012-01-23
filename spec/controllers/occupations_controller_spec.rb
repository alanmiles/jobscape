require 'spec_helper'

describe OccupationsController do
  render_views
  
  before(:each) do
    @sector = Factory(:sector)
  end
  
  describe "for non-signed-in users" do
    
    describe "GET 'index'" do
      
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
  
    end
    
    
    describe "GET 'new'" do
      
      it "should deny access" do
        get :new
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
  
    end
    
    describe "DELETE 'destroy'" do
      before(:each) do
        @occupation = Factory(:occupation)
      end
      
      it "should deny access" do
        delete :destroy, :id => @occupation
        response.should redirect_to(signin_path)
      end
      
    end
  end
  
  
  describe "for signed-in non-administrators" do
  
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    describe "GET 'index'" do
      it "should deny access" do
        get :index
        response.should redirect_to(root_path)
        flash[:notice].should =~ /available to administrators/i
      end
    end
    
    describe "GET 'new'" do
      it "should deny access" do
        get :new
        response.should redirect_to(root_path)
        flash[:notice].should =~ /available to administrators/i
      end
    end
    
    describe "DELETE 'destroy'" do
      before(:each) do
        @occupation = Factory(:occupation)
      end
      
      it "should deny access" do
        delete :destroy, :id => @occupation
        response.should redirect_to(root_path)
      end
      
    end
  end
  
  
  describe "for signed-in administrators" do
  
    before(:each) do
      @admin = Factory(:user, :email => "admin@example.com", :admin => true)   
      test_sign_in(@admin)
    end
    
    describe "GET 'index'" do

      before(:each) do
        @occ_1 = Factory(:occupation)
        @occ_2 = Factory(:occupation, :name => "Marketing")
        @occ_3 = Factory(:occupation, :name => "Administration")
        @occupations = [@occ_1, @occ_2, @occ_3] 
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector(".title-text", :content => "Occupations")      
      end
      
      it "should list alphabetically each Occupation in the database" do
        get :index
        @occupations.each do |occupation|
          response.should have_selector("a", :content => occupation.name)
        end
      end
      
      it "should not have a delete button if it is connected to an actual job"
    end
    
    describe "GET 'new'" do
      it "should be successful" do
        get :new
        response.should be_success
      end
      
      it "should have the right title" do
        get :new
        response.should have_selector(".title-text", :content => "New occupation")
      end
      
    end
    
    describe "POST 'create'" do

      describe "failure" do

        before(:each) do
          @nm = ""
          @attr = { :name => @nm }
        end

        it "should not create an occupation" do
          lambda do
            post :create, :occupation => @attr
          end.should_not change(Occupation, :count)
        end

        it "should have the right title" do
          post :create, :occupation => @attr
          response.should have_selector("title", :content => "New occupation")
        end

        it "should render the 'new' page" do
          post :create, :occupation => @attr
          response.should render_template('new')
        end
      end
    
      describe "success" do

        before(:each) do
          @nm = "Security"
          @attr = { :name => @nm }
        end

        it "should create an occupation" do
          lambda do
            post :create, :occupation => @attr
          end.should change(Occupation, :count).by(1)
        end

        it "should redirect to the occupation list" do
          post :create, :occupation => @attr
          response.should redirect_to occupations_path
        end
      
        it "should have a success message" do
          post :create, :occupation => @attr
          flash[:success].should == "'" + @nm + "' added."
        end    
      end     
        
    end
    
    describe "GET 'edit'" do
     
      before(:each) do
        @occupation = Factory(:occupation)
      end
      
      it "should be successful" do
        get :edit, :id => @occupation
        response.should be_success
      end
      
      it "should have the right title" do
        get :edit, :id => @occupation        
        response.should have_selector(".title-text", :content => "Edit occupation")
      end
      
    end
    
    describe "PUT 'update'" do

      before(:each) do
        @occupation = Factory(:occupation)
      end

      describe "failure" do

        before(:each) do
          @attr = { :name => "" }
        end

        it "should render the 'edit' page" do
          put :update, :id => @occupation, :occupation => @attr
          response.should render_template('edit')
        end

        it "should have the right title" do
          put :update, :id => @occupation, :occupation => @attr
          response.should have_selector("title", :content => "Edit occupation")
        end
      end
      
      describe "success" do

        before(:each) do
          @attr = { :name => "Accountancy" }
        end

        it "should change the occupation's attributes" do
          put :update, :id => @occupation, :occupation => @attr
          @occupation.reload
          @occupation.name.should  == @attr[:name]
        end

        it "should redirect to the occupation list" do
          put :update, :id => @occupation, :occupation => @attr
          response.should redirect_to occupations_path
        end

        it "should have a flash message" do
          put :update, :id => @occupation, :occupation => @attr
          flash[:success].should == "'" + @attr[:name] + "' updated."
        end
      end
    end
    
    describe "DELETE 'destroy'" do
    
      before(:each) do
        @occupation = Factory(:occupation)
        request.env["HTTP_REFERER"] = occupations_path
      end
      
      describe "success" do
      
        it "should destroy the occupation" do
          lambda do
            delete :destroy, :id => @occupation
          end.should change(Occupation, :count).by(-1)
        end

        it "should redirect to the occupations list" do
          delete :destroy, :id => @occupation
          response.should redirect_to(occupations_path)
        end
        
        it "should have a success message" do
          delete :destroy, :id => @occupation
          flash[:success].should == "'" + @occupation.name + "' removed."
        end
      
      end
      
      describe "failure" do
      
        describe "when the occupation is linked to existing jobs" do
       
          before(:each) do
            @business = Factory(:business, :sector_id => @sector.id)
            @department = Factory(:department, :business_id => @business.id)
            @job = Factory(:job, :business_id => @business.id, 
                           :department_id => @department.id, :occupation_id => @occupation.id)
          end
          
          it "should not delete an occupation that's linked to a job" do
            lambda do
              delete :destroy, :id => @occupation
              flash[:error].should == " Cannot delete occupation while associated jobs exist"
            end.should_not change(Occupation, :count)
          end
        end
      end
      
    
    end  
  end

end
