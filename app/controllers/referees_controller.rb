class RefereesController < ApplicationController
  
  def index
    @user = current_user
    @referees = @user.referees
    @portrait = Portrait.find_by_user_id(@user)
    @title = "References"
  end

  def new
    @user = current_user
    @referee = @user.referees.new
    @title = "New reference"
    @relationships = Referee::RELATIONSHIP_TYPES
  end
  
  def create
    @user = current_user
    @portrait = Portrait.find_by_user_id(@user)
    @referee = @user.referees.new(params[:referee])
    if @referee.save
      if @user.max_referees?
        if @portrait.public?
          flash[:success] = "Reference successfully added - you've now entered all 3 references allowed."
        else
          flash[:success] = "Reference successfully added - you've now entered all 3 references allowed.
              Don't forget that if you want to apply for jobs you'll need to make the Portrait public - click on 
              'Full Portrait', and then update 'And finally...'."
        end
      else
        if @user.referees.count == 2
          if @portrait.public?
            flash[:success] = "Reference successfully added."
          else
            flash[:success] = "Reference successfully added.  You now have 2 references, so you can now make your Portrait
                public and start applying for jobs posted on the site.  To do so, update 'And finally...' on the 
                Portrait page."
          end
        else
          flash[:success] = "Reference successfully added."
        end
      end
      if @user.portrait.public?
        @code = Referee.generate_code
        @referee.update_attribute(:access_code, @code)
        RefereeMailer.request_response(@referee).deliver
      end
      redirect_to user_referees_path(@user)
    else
      @title = "New reference"
      @relationships = Referee::RELATIONSHIP_TYPES
      render 'new'
    end
  end

  def edit
    @user = current_user
    @referee = Referee.find(params[:id])
    @title = "Edit reference"
    @relationships = Referee::RELATIONSHIP_TYPES
  end
  
  def update
    @referee = Referee.find(params[:id])
    if @referee.update_attributes(params[:referee])
      flash[:success] = "Reference updated."
      redirect_to user_referees_path(@referee.user_id)
    else
      @title = "Edit reference"
      @relationships = Referee::RELATIONSHIP_TYPES
      render 'edit'
    end
  end
  
  def destroy
    @referee = Referee.find(params[:id])
    @user = User.find(@referee.user_id)
    @referee.destroy
    if @user.referees.count < 2
      @portrait = Portrait.find_by_user_id(@user)
      if @portrait.public?
        @portrait.update_attribute(:public, false)
        flash[:success] = "#{@referee.name} removed from list. With only one reference, your Portrait is no longer public.
            If you want employers to see it, you'll need to add another reference."
      else
        flash[:success] = "#{@referee.name} removed from list."
      end
    else
      flash[:success] = "#{@referee.name} removed from list."
    end
    redirect_to user_referees_path(@referee.user_id)
  end
end
