class Admin::TransactionsController < ApplicationController
  layout 'admin'
  before_filter :check_admin
  def index
   @transactions = Order.find(:all)
   @total_amount_of_transactions = Order.find(:all,:select => 'sum(amount) as amount').first.amount.to_f
  end

end
