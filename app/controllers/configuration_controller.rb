require "rake"

class ConfigurationController < ApplicationController
  def index
  end

  def reset_database
    if params[:confirmation_text] == "CONFIRMAR"
      begin
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE transactions RESTART IDENTITY CASCADE;")
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE stores RESTART IDENTITY CASCADE;")
        flash[:notice] = "Database successfully cleared. All stores and transactions have been removed and indexes restarted."
      rescue => e
        flash[:alert] = "Error clearing database: #{e.message}"
      end
    else
      flash[:alert] = "Incorrect confirmation text."
    end
    redirect_to configuration_path
  end
end
