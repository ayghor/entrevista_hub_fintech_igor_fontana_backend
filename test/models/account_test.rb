require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  setup do
    @root = accounts(:one)
    @child = accounts(:two)
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
  test "valid child" do
    assert @child.valid?
  end

  test "valid root" do
    assert @root.valid?
  end

  #
  # nome inválido
  #
  test "invalid if name absent" do
    @child.name = ""
    refute @child.valid?
    assert @child.errors.added?(:name, :blank)
  end

  test "invalid if name is not unique" do
    @child.name = @root.name
    refute @child.valid?
    assert @child.errors.added?(:name, :taken)
  end

  #
  # mãe inválida
  #
  test "invalid if is_child and parent absent" do
    assert @child.is_child
    @child.parent = nil
    refute @child.valid?
    assert @child.errors.added?(:parent, :blank)
  end

  test "invalid if !is_child and parent present" do
    refute @root.is_child
    @root.parent = accounts(:one)
    refute @root.valid?
    assert @root.errors.added?(:parent, :present)
  end

  #
  # matriz inválida
  #
  test "invalid if root absent" do
    assert @child.is_child
    @child.root = nil
    refute @child.valid?
    assert @child.errors.added?(:root, :blank)
  end

  test "invalid if is_child and root != parent.root" do
    assert @child.is_child
    @child.root = accounts(:zero)
    refute @child.valid?
    assert @child.errors.added?(:root, :parent_root)
  end

  #
  # dono inválido
  #
  test "invalid if owner is absent" do
    @child.owner = nil
    refute @child.valid?
    assert @child.errors.added?(:owner, :blank)
  end
end
