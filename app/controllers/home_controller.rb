class HomeController < ApplicationController


  def index
    @order = Order.new
  end

  def create

    @order = Order.new(params[:order])

    if @order.save
      flash[:success] = I18n.t :success

      payment = PagSeguro::PaymentRequest.new
      payment.reference = @order.id
      payment.redirect_url = 'http://quemvaicair.herokuapp.com'

      payment.items << {
          id: @order.product_id,
          description: t(:bolao),
          amount: 5.00,
          weight: 0
      }

      response = payment.register

      if response.errors.any?
        raise response.errors.join("\n")
      else
        redirect_to response.url
      end

      @product = Product.find(@order.product_id)

      #Envio de e-mail
      message = NotifierController.sendmail(@order.email, @product.nome)  # => Returns a Mail::Message object
      message.deliver

    else
      flash[:error] = I18n.t :error
      redirect_to 'http://quemvaicair.herokuapp.com/#form-pay'
    end

  end

end