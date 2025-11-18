class Transaction < ApplicationRecord
  belongs_to :store

  # Tipos de transação conforme documentação
  TRANSACTION_TYPES = {
    1 => { description: 'Débito', nature: 'Entrada', signal: '+' },
    2 => { description: 'Boleto', nature: 'Saída', signal: '-' },
    3 => { description: 'Financiamento', nature: 'Saída', signal: '-' },
    4 => { description: 'Crédito', nature: 'Entrada', signal: '+' },
    5 => { description: 'Recebimento Empréstimo', nature: 'Entrada', signal: '+' },
    6 => { description: 'Vendas', nature: 'Entrada', signal: '+' },
    7 => { description: 'Recebimento TED', nature: 'Entrada', signal: '+' },
    8 => { description: 'Recebimento DOC', nature: 'Entrada', signal: '+' },
    9 => { description: 'Aluguel', nature: 'Saída', signal: '-' }
  }.freeze

  validates :transaction_type, presence: true, inclusion: { in: TRANSACTION_TYPES.keys }
  validates :date, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :cpf, presence: true, length: { is: 11 }
  validates :card, presence: true, length: { maximum: 12 }
  validates :time, presence: true
  validates :nature, presence: true

  # Métodos auxiliares
  def entrada?
    TRANSACTION_TYPES[transaction_type][:nature] == 'Entrada'
  end

  def saida?
    !entrada?
  end

  def type_description
    TRANSACTION_TYPES[transaction_type][:description]
  end

  def signal
    TRANSACTION_TYPES[transaction_type][:signal]
  end
end

