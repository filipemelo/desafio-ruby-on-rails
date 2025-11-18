class CnabParser
  # Formato CNAB (81 caracteres por linha)
  # Documentação oficial:
  # Campo          Início  Fim  Tamanho  Comentário
  # Tipo           1       1    1        Tipo da transação
  # Data           2       9    8        Data da ocorrência (YYYYMMDD)
  # Valor          10      19   10       Valor da movimentação (dividir por 100.00)
  # CPF            20      30   11       CPF do beneficiário
  # Cartão         31      42   12       Cartão utilizado na transação
  # Hora           43      48   6        Hora da ocorrência (HHMMSS, UTC-3)
  # Dono da loja   49      62   14       Nome do representante da loja
  # Nome loja      63      81   19       Nome da loja
  #
  # Nota: Posições são baseadas em 1 (não 0), então no código Ruby:
  # - Posição 1 = índice 0
  # - Posição 2 = índice 1
  # - etc.

  class ParseError < StandardError; end

  def self.parse(file)
    new(file).parse
  end

  def initialize(file)
    @file = file
    @errors = []
  end

  def parse
    stores_data = {}

    @file.readlines.each_with_index do |line, index|
      # Remove todos os caracteres de quebra de linha (\r, \n, etc)
      line = line.chomp.chomp("\r")
      next if line.blank?

      # Remove espaços em branco apenas do final (caso tenha espaço extra)
      line = line.rstrip

      begin
        transaction_data = parse_line(line)
        store_key = transaction_data[:store_name]

        stores_data[store_key] ||= {
          name: transaction_data[:store_name],
          owner: transaction_data[:store_owner],
          transactions: []
        }

        stores_data[store_key][:transactions] << transaction_data.except(:store_name, :store_owner)
      rescue ParseError => e
        @errors << "Linha #{index + 1}: #{e.message}"
      end
    end

    { stores: stores_data, errors: @errors }
  end

  private

  def parse_line(line)
    # Remove espaços extras do final
    line = line.rstrip

    # Exige no mínimo 48 caracteres (até o fim da hora)
    raise ParseError, "Linha muito curta: deve ter pelo menos 48 caracteres (encontrado: #{line.length})" if line.length < 48

    # Extração dos campos conforme documentação (posições baseadas em 1, índices em 0)
    # Lê de forma segura, pegando o máximo disponível
    transaction_type = line[0]&.to_i || 0              # Posição 1 (índice 0): Tipo

    # Campos obrigatórios (deve ter pelo menos até aqui)
    date_str = safe_slice(line, 1, 8)                   # Posições 2-9 (índices 1-8): Data
    amount_str = safe_slice(line, 9, 18)                # Posições 10-19 (índices 9-18): Valor
    cpf = safe_slice(line, 19, 29)&.strip || ""        # Posições 20-30 (índices 19-29): CPF
    card = safe_slice(line, 30, 41)&.strip || ""       # Posições 31-42 (índices 30-41): Cartão
    time_str = safe_slice(line, 42, 47)                 # Posições 43-48 (índices 42-47): Hora

    # Campos opcionais (podem não existir completamente)
    # Dono da loja começa na posição 49 (índice 48) e vai até 62 (índice 61), mas pode ter menos
    owner_start = 48
    owner_end = [ 61, line.length - 1 ].min

    # Nome da loja começa na posição 63 (índice 62) e vai até o final da linha
    store_start = 62
    store_end = line.length - 1

    # Se a linha tem menos de 63 caracteres, não tem nome da loja separado
    if line.length < 63
      # Dono da loja vai até o final
      owner = safe_slice(line, owner_start, line.length - 1)&.strip || ""
      store_name = ""
    else
      # Dono da loja de 48 até 61
      owner = safe_slice(line, owner_start, owner_end)&.strip || ""
      # Nome da loja de 62 até o final
      store_name = safe_slice(line, store_start, store_end)&.strip || ""
    end

    raise ParseError, "Tipo de transação inválido: #{transaction_type}" unless Transaction::TRANSACTION_TYPES.key?(transaction_type)

    # Parse da data
    begin
      date = Date.strptime(date_str, "%Y%m%d")
    rescue ArgumentError
      raise ParseError, "Data inválida: #{date_str}"
    end

    # Parse do valor (dividir por 100 conforme documentação: valor / 100.00)
    amount = BigDecimal(amount_str) / 100

    # Parse da hora
    begin
      hour = time_str[0..1].to_i
      minute = time_str[2..3].to_i
      second = time_str[4..5].to_i
      time = Time.zone.parse("#{hour}:#{minute}:#{second}").to_time
    rescue ArgumentError
      raise ParseError, "Hora inválida: #{time_str}"
    end

    nature = Transaction::TRANSACTION_TYPES[transaction_type][:nature]

    {
      transaction_type: transaction_type,
      date: date,
      amount: amount,
      cpf: cpf,
      card: card,
      time: time,
      nature: nature,
      store_name: store_name,
      store_owner: owner
    }
  end

  # Helper method para extrair substring de forma segura
  def safe_slice(str, start_idx, end_idx)
    return "" if str.nil? || str.empty?
    return "" if start_idx < 0 || start_idx >= str.length
    return "" if end_idx < start_idx

    # Garante que end_idx não ultrapassa o tamanho da string
    end_idx = [ end_idx, str.length - 1 ].min
    str[start_idx..end_idx]
  end
end
