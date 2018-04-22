class Account < ApplicationRecord
  #
  #
  # associações
  #
  #
  #
  belongs_to :root, class_name: :Account
  belongs_to :parent, class_name: :Account, optional: true
  belongs_to :owner, class_name: :Person
  has_many :credits, foreign_key: :to_id, class_name: :Transfer
  has_many :debits, foreign_key: :from_id, class_name: :Transfer

  #
  #
  #
  # validações
  #
  #
  #

  #
  # nome
  #
  validates :name,
    presence: true,
    uniqueness: true

  #
  # conta mãe
  #
  validates :parent,
    if: :is_child,
    presence: true

  validates :parent,
    unless: :is_child,
    absence: true

  #
  # conta matriz
  #
  validates_each :root do |r, a, v|
    if r.is_child && r.parent && r.root != r.parent.root
      r.errors.add(:root, :parent_root, message: "Root does not match parent")
    end
  end

  #
  #
  #
  # callbacks
  #
  #
  #
  before_validation :guess_attributes,
    if: :new_record?

  private

  def guess_attributes
    self.is_child = !!parent if is_child.nil?
    self.root = is_child ? parent&.root : self if root.nil?
  end
end
