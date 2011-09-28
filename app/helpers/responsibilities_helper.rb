module ResponsibilitiesHelper

  def evaluation
    if @responsibility.rating == 0
      link_to "(Set now)", edit_evaluation_path(@evaluation)
    else
      link_to "(Re-calculate)", edit_evaluation_path(@evaluation)
    end
  end
  
end
