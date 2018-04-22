require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  setup do
    @fisica = people(:one)
    @juridica = people(:two)
  end

  #
  #
  #
  # validações
  #
  #
  #

  #
  # válida
  #
  test "valid pessoa fisica" do
    assert @fisica.valid?
  end

  test "valid pessoa jurídica" do
    assert @juridica.valid?
  end

  #
  # nome inválido
  #
  test "invalid if name absent" do
    @fisica.name = ""
    refute @fisica.valid?
    assert @fisica.errors.added?(:name, :blank)
  end

  #
  # cpf/cnpj inválido
  # TODO: testar com mais força?
  #
  test "invalid if cpf/cnpj absent" do
    @fisica.cpf_cnpj = ""
    refute @fisica.valid?
    assert @fisica.errors.added?(:cpf_cnpj, :blank)
  end

  test "invalid if cpf/cnpj is not unique" do
    @fisica.cpf_cnpj = people(:zero).cpf_cnpj
    refute @fisica.valid?
    assert @fisica.errors.added?(:cpf_cnpj, :taken)
  end

  test "invalid if cpf/cnpj is not numeric" do
    @fisica.cpf_cnpj = "0000000000a"
    refute @fisica.valid?
    assert @fisica.errors.added?(:cpf_cnpj, :not_a_number)
  end

  test "invalid if cpf length is not 11" do
    @fisica.cpf_cnpj = "0000000000"
    refute @fisica.valid?
    assert @fisica.errors.added?(:cpf_cnpj, :wrong_length, count: 11)
  end

  test "invalid if cnpj length is not 14" do
    @juridica.is_juridica = true
    @juridica.cpf_cnpj = "000000000000000"
    refute @juridica.valid?
    assert @juridica.errors.added?(:cpf_cnpj, :wrong_length, count: 14)
  end
end
