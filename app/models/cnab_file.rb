class CnabFile
  include ActiveModel::Model

  attr_accessor :file
  attr_accessor :import_result

  validates :file, presence: true

  def save
    return false unless valid?

    # Processa o arquivo CNAB
    @import_result = CnabImporter.import(@file)

    if @import_result[:success]
      true
    else
      @import_result[:errors].each do |error|
        errors.add(:base, error)
      end
      false
    end
  end
end
