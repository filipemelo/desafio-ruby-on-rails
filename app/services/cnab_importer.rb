class CnabImporter
  def self.import(file)
    new(file).import
  end

  def initialize(file)
    @file = file
    @parsed_data = nil
    @imported_count = 0
    @errors = []
  end

  def import
    # Abre o arquivo para leitura
    file_to_parse = @file.respond_to?(:open) ? @file.open : @file

    # Parse do arquivo
    @parsed_data = CnabParser.parse(file_to_parse)

    return { success: false, errors: @parsed_data[:errors] } if @parsed_data[:errors].any?

    # Importa os dados
    ActiveRecord::Base.transaction do
      @parsed_data[:stores].each do |store_key, store_data|
        store = Store.find_or_create_by!(name: store_data[:name]) do |s|
          s.owner = store_data[:owner]
        end

        # Atualiza o owner se mudou
        store.update!(owner: store_data[:owner]) if store.owner != store_data[:owner]

        store_data[:transactions].each do |transaction_data|
          Transaction.create!(
            store: store,
            transaction_type: transaction_data[:transaction_type],
            date: transaction_data[:date],
            amount: transaction_data[:amount],
            cpf: transaction_data[:cpf],
            card: transaction_data[:card],
            time: transaction_data[:time],
            nature: transaction_data[:nature],
            description: Transaction::TRANSACTION_TYPES[transaction_data[:transaction_type]][:description]
          )
          @imported_count += 1
        end
      end
    end

    { success: true, imported_count: @imported_count, stores_count: @parsed_data[:stores].count }
  rescue ActiveRecord::RecordInvalid => e
    { success: false, errors: [ "Erro ao salvar no banco: #{e.message}" ] }
  rescue StandardError => e
    { success: false, errors: [ "Erro inesperado: #{e.message}" ] }
  end
end
