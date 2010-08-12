class Admin::TransactionsController < ApplicationController
  layout 'admin'
  before_filter :check_admin
  
  def index
   @transactions = Order.find(:all,:conditions => ['status = ?', 'success'])
   @total_amount_of_transactions = Order.find(:all,:conditions => ['status = ?', 'success'],:select => 'sum(amount) as amount').first.amount.to_f unless @transactions.blank?
   @paypal_fees = Order.find(:all,:conditions => ['status = ?', 'success'],:select => 'sum(paypal_fee) as paypal').first.paypal.to_f unless @transactions.blank?
   processing_fees = Order.find(:all,:conditions => ['status = ?', 'success'],:select => 'sum(processing_fee) as processing_fee').first.processing_fee.to_f unless @transactions.blank?
   
   @paypal_fees += processing_fees if processing_fees
   
   @little_surprizes_fees = Order.find(:all,:conditions => ['status = ?', 'success'],:select => 'sum(little_surprizes_fee) as little_surprizes_fee').first.little_surprizes_fee.to_f unless @transactions.blank?
   
  end

end
