class StoresController < ApplicationController
  def index
    begin
      @stores = Store.includes(:transactions).order(:name)
    rescue ActiveRecord::StatementInvalid => e
      if e.message =~ /relation .*stores.* does not exist/
        @stores = []
      else
        raise
      end
    end
  end
end

