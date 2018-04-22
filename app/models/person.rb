class Person < ApplicationRecord
  #
  #
  # associações
  #
  #
  #
  has_many :accounts, foreign_key: :owner_id

  #
  #
  #
  # validações
  #
  #
  #

  #
  # nome e cpf/cnpj
  #
  validates :name,
    presence: true

  #
  # cpf/cnpj
  # TODO: checar dígitos mágicos
  #
  validates :cpf_cnpj,
    presence: true,
    numericality: {only_integer: true},
    uniqueness: true

  validates :cpf_cnpj,
    unless: :is_juridica,
    length: {is: 11}

  validates :cpf_cnpj,
    if: :is_juridica,
    length: {is: 14}
end
