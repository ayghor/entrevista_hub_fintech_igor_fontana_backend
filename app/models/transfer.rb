class Transfer < ApplicationRecord
  #
  #
  #
  # queries
  #
  #
  #
  scope :is_aporte, -> { where(is_aporte: true) }
  scope :not_aporte, -> { where.not(is_aporte: true) }
  scope :is_reversal, -> { where(is_reversal: true) }

  #
  #
  #
  # associações
  #
  #
  #
  belongs_to :reverse, class_name: :Transfer, optional: true
  belongs_to :from, class_name: :Account
  belongs_to :to, class_name: :Account

  #
  #
  #
  # validações
  #
  #
  #

  #
  # origem
  #
  validates_each :from do |r, a, v|
    if r.is_reversal && r.reverse && r.from != r.reverse.to
      r.errors.add(:from, :not_reverse_to, message: "Bad reversal")
    end
    if r.from
      if r.is_reversal && r.is_aporte == r.from.is_child
        r.errors.add(:from, :bad_is_child, message: "Bad is_child for is_aporte")
      end
    end
  end

  #
  # destino
  #
  validates_each :to do |r, a, v|
    if r.is_reversal && r.reverse && r.to != r.reverse.from
      r.errors.add(:to, :not_reverse_from, message: "Bad reversal")
    end
    if r.to
      if !r.is_reversal && r.is_aporte == r.to.is_child
        r.errors.add(:to, :bad_is_child, message: "Bad is_child for is_aporte")
      end
      r.errors.add(:to, :blocked, message: "Blocked") if r.to.is_blocked
      r.errors.add(:to, :canceled, message: "Canceled") if r.to.is_canceled

      if !r.is_aporte && r.from && r.to.root != r.from.root
        r.errors.add(:to, :bad_root, message: "Must be in same subtree as from")
      end
    end
  end

  #
  # montante
  #
  validates :amount,
    presence: true

  validates_each :amount do |r, a, v|
    if r.is_reversal && r.reverse && r.amount != r.reverse.amount
      r.errors.add(:amount, :not_reverse_amount, message: "Bad reversal")
    end
  end

  #
  # inversa, caso seja um estorno
  #
  validates :reverse,
    if: :is_reversal,
    presence: true

  #
  # código, caso seja um aporte
  #
  validates :code,
    if: :is_aporte,
    presence: true,
    length: {is: 22},
    format: /\A[A-Za-z0-9]*\z/,
    uniqueness: {scope: :is_reversal, allow_nil: true}

  validates :code,
    unless: :is_aporte,
    absence: true

  # igual ao da inversa, caso seja um estorno
  validates_each :code do |r, a, v|
    if r.is_reversal && r.reverse && r.code != r.reverse.code
      r.errors.add(a, :reverse_code, message: "Bad code")
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

  after_create :update_reverse_reverse,
    if: :is_reversal

  after_create :update_accounts_amounts

  private

  def guess_attributes
    self.is_reversal = !!reverse if is_reversal.nil?
    if is_reversal
      set_random_code if code.nil?
      if reverse
        self.amount = reverse.amount if amount.nil?
        self.from = reverse.to if from.nil?
        self.to = reverse.from if to.nil?
      end
    end

    self.is_aporte =
      if is_reversal?
        reverse&.is_aporte
      else
        to&.is_child.nil? ? nil : !to.is_child
      end
  end

  def set_random_code
    self.code = SecureRandom.alphanumeric(22)
  end

  def update_reverse_reverse
    reverse.update!(reverse: self)
  end

  def update_accounts_amounts
    from.amount -= amount
    to.amount += amount
    from.save!
    to.save!
  end
end
