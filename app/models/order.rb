class Order < ActiveRecord::Base
  has_one :transaction, :class_name => "OrderTransaction"

  def express_token=(token)
    self[:express_token] = token
    if new_record? && !token.blank?
      details = EXPRESS_GATEWAY.details_for(token)
      self.express_payer_id = details.payer_id
      self.first_name = details.params["first_name"]
      self.last_name = details.params["last_name"]
      self.ammount = details.params["order_total"]
    end
  end

  def purchase
    response = process_purchase
    self.build_transaction
    transaction.create!(:response => response)
    response.success?
  end

  private

  def process_purchase
    EXPRESS_GATEWAY.purchase(self.ammount, express_purchase_options)
  end

  def express_purchase_options
    {
      :ip => ip_address,
      :token => express_token,
      :payer_id => express_payer_id
    }
  end

end

