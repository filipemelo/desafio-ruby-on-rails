class CnabFilesController < ApplicationController
  def new
    @cnab_file = CnabFile.new
  end

  def create
    @cnab_file = CnabFile.new(cnab_file_params)

    if @cnab_file.save
      result = @cnab_file.import_result
      notice = "CNAB file processed successfully! #{result[:imported_count]} transactions imported from #{result[:stores_count]} store(s)."
      redirect_to stores_path, notice: notice
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def cnab_file_params
    params.require(:cnab_file).permit(:file)
  end
end
