require 'test_helper'

class TransferTest < ActiveSupport::TestCase
  setup do
    @root = transfers(:one)
    @child = transfers(:two)
    @rchild = transfers(:three)
    @rroot = transfers(:four)
  end

  #
  # válida
  #
  test "valid root transfer" do
    refute @root.is_child
    assert @root.valid?
  end

  test "valid child transfer" do
    assert @child.is_child
    assert @child.valid?
  end

  test "valid child reversal" do
    assert @rchild.is_child
    assert @rchild.is_reversal
    assert @rchild.valid?
  end

  test "valid root reversal" do
    refute @rroot.is_child
    assert @rroot.is_reversal
    assert @rroot.valid?
  end

  #
  # montante
  #
  test "invalid if amount absent" do
    @root.amount = nil
    refute @root.valid?
    assert @root.errors.added?(:amount, :blank)
  end

  #
  # origem e destino
  #
  test "invalid if from absent" do
    @root.from = nil
    refute @root.valid?
    assert @root.errors.added?(:from, :blank)
  end

  test "invalid if to absent" do
    @root.to = nil
    refute @root.valid?
    assert @root.errors.added?(:to, :blank)
  end

  #
  # estorno
  #
  test "invalid if is_reversal and reverse absent" do
    @rroot.reverse = nil
    refute @rroot.valid?
    assert @rroot.errors.added?(:reverse, :blank)
  end

  test "invalid if is_reversal and from != reverse.to" do
    @rroot.from = accounts(:two)
    refute @rroot.valid?
    assert @rroot.errors.added?(:from, :not_reverse_to)
  end

  test "invalid if is_reversal and to != reverse.from" do
    @rroot.to = accounts(:two)
    refute @rroot.valid?
    assert @rroot.errors.added?(:to, :not_reverse_from)
  end

  test "invalid if is_reversal and amount != reverse.amount" do
    @rroot.amount = 8437
    refute @rroot.valid?
    assert @rroot.errors.added?(:amount, :not_reverse_amount)
  end

  #
  # código
  #
  test "invalid if code is not alphanumeric" do
    @root.code = "aaaaaaaaaaaaaaaaaaaaa_"
    refute @root.valid?
    assert @root.errors.added?(:code, :invalid)
  end

  test "invalid if code length is not 22" do
    @root.code = "aaaaaaaaaaaaaaaaaaaaa"
    refute @root.valid?
    assert @root.errors.added?(:code, :wrong_length)
  end

  test "invalid if (is_reversal, code) is not unique" do
    refute @root.is_reversal
    @root.code = transfers(:seven).code
    refute @root.valid?
    assert @root.errors.added?(:code, :taken)
  end

  test "invalid if is_reversal and code != reverse.code" do
    @rroot.code = "wwwwwwwwwwwwwwwwwwwwww"
    refute @rroot.valid?
    assert @rroot.errors.added?(:code, :reverse_code)
  end

end