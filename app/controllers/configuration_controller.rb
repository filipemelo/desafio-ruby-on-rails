require "rake"

class ConfigurationController < ApplicationController
  def index
  end

  def reset_database
    if params[:confirmation_text] == "CONFIRMAR"
      Rails.application.load_tasks unless Rake::Task.task_defined?("db:reset")
      Rake::Task["db:reset"].reenable
      Rake::Task["db:reset"].invoke
      flash[:notice] = "Banco de dados resetado com sucesso."
    else
      flash[:alert] = "Texto de confirmação incorreto."
    end
    redirect_to configuration_path
  end
end
