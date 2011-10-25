module MyApplicationsHelper

  def application_message
    if @application.personal_statement.empty?
      return " ... nothing!"
    else
      @application.personal_statement
    end
  end
end
