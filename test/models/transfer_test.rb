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
    assert @root.is_aporte
    assert @root.valid?
  end

  test "valid child transfer" do
    refute @child.is_aporte
    assert @child.valid?
  end

  test "valid child reversal" do
    refute @rchild.is_aporte
    assert @rchild.is_reversal
    assert @rchild.valid?
  end

  test "valid root reversal" do
    assert @rroot.is_aporte
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

  test "invalid if to blocked" do
    @child.to = accounts(:blocked)
    refute @child.valid?
    assert @child.errors.added?(:to, :blocked)
  end

  test "invalid if to canceled" do
    @child.to = accounts(:canceled)
    refute @child.valid?
    assert @child.errors.added?(:to, :canceled)
  end

  test "invalid if !is_reversal and is_aporte == to.is_child" do
    @child.to.is_child = !@child.to.is_child
    refute @child.valid?
    assert @child.errors.added?(:to, :bad_is_child)
  end

  test "invalid if is_reversal and is_aporte == from.is_child" do
    @rchild.from.is_child = !@rchild.from.is_child
    refute @rchild.valid?
    assert @rchild.errors.added?(:from, :bad_is_child)
  end

  test "invalid if !is_aporte and to.root != from.root" do
    @child.from.root = accounts(:one)
    @child.to.root = accounts(:two)
    refute @child.valid?
    assert @child.errors.added?(:to, :bad_root)
  end

  test "accounts amounts are updated" do
    from = accounts(:one)
    to = accounts(:two)
    assert_difference 'from.amount', -6.66 do
      assert_difference 'to.amount', 6.66 do
        Transfer.create!(from: from, to: to, amount: 6.66)
      end
    end
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

  test "new reversal sets reverse on reverse" do
    x = Transfer.create!(
      reverse: transfers(:seven),
      code: transfers(:seven).code
    )
    x.reload
    x.reverse.reload
    assert_equal x.reverse.reverse, x
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
