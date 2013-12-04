class HomeController < ApplicationController


  def index
    @order = Order.new
  end

  def create
    @order = Order.new(params[:order])

    if @order.save
      flash[:success] = I18n.t :success
    else
      flash[:error] = I18n.t :error
    end

    payment = PagSeguro::PaymentRequest.new
    payment.reference = @order.id
    payment.redirect_url = 'http://quemvaicair.herokuapp.com'

    payment.items << {
        id: @order.product_id,
        description: t(:bolao),
        amount: 1.00,
        weight: 0
    }

    response = payment.register

    if response.errors.any?
      raise response.errors.join("\n")
    else
      redirect_to response.url
    end

  end



end