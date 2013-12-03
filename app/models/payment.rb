class Payment < ActiveRecord::Base

  attr_accessible :amount, :digital, :recurring, :popup

  validates :token, uniqueness: true
  validates :amount, presence: true
  validates :identifier, uniqueness: true
  scope :recurring, where(recurring: true)
  scope :digital,   where(digital: true)
  scope :popup,     where(popup: true)

  def goods_type
    digital? ? :digital : :real
  end

  def payment_type
    recurring? ? :recurring : :instant
  end

  def ux_type
    popup? ? :popup : :redirect
  end

  def details
    if recurring?
      client.subscription(self.identifier)
    else
      client.details(self.token)
    end
  end

  attr_reader :redirect_uri, :popup_uri
  def setup!(return_url, cancel_url)
    response = client.setup(
        payment_request,
        return_url,
        cancel_url,
        pay_on_paypal: true,
        no_shipping: self.digital?
    )
    self.token = response.token
    self.save!
    @redirect_uri = response.redirect_uri
    @popup_uri = response.popup_uri
    self
  end

  def cancel!
    self.canceled = true
    self.save!
    self
  end

  def complete!(payer_id = nil)
    if self.recurring?
      response = client.subscribe!(self.token, recurring_request)
      self.identifier = response.recurring.identifier
    else
      response = client.checkout!(self.token, payer_id, payment_request)
      self.payer_id = payer_id
      self.identifier = response.payment_info.first.transaction_id
    end
    self.completed = true
    self.save!
    self
  end

  def unsubscribe!
    client.renew!(self.identifier, :Cancel)
    self.cancel!
  end

  private

  def client
    Paypal::Express::Request.new(
        :username   => 'helenamcfreire_api1.gmail.com',
        :password   => '6JEV4Z56HVMLKC26',
        :signature  => 'Aly591PCNMimJp2302m0zl2yO0dQApdAXyvhGAzqyEFqsn6I0m1r7an1'
    )
  end

  def payment_request

    Paypal::Payment::Request.new(
        :currency_code => :BRL,   # if nil, PayPal use USD as default
        :description   => 'Participe do bolao dos desesperados!',    # item description
        :quantity      => 1,      # item quantity
        :amount        => 1.00,   # item value
    )

  end

end
