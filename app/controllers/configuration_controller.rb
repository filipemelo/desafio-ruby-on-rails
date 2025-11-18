require "rake"

class ConfigurationController < ApplicationController
  def index
  end

  def reset_database
    if params[:confirmation_text] == "CONFIRMAR"
      begin
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE transactions RESTART IDENTITY CASCADE;")
        ActiveRecord::Base.connection.execute("TRUNCATE TABLE stores RESTART IDENTITY CASCADE;")
        flash[:notice] = "Banco de dados limpo com sucesso. Todas as lojas e transações foram removidas e os índices reiniciados."
      rescue => e
        flash[:alert] = "Erro ao limpar banco: #{e.message}"
      end
    else
      flash[:alert] = "Texto de confirmação incorreto."
    end
    redirect_to configuration_path
  end
end
