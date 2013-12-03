class HomeController < ApplicationController


  def index
    @payment = Payment.digital.popup.build
  end

  def apostar

    payment = Payment.create! params[:payment]
    payment.setup!(
        'http://quemvaicair.herokuapp.com',
        'http://quemvaicair.herokuapp.com'
    )
    if payment.popup?
      redirect_to payment.popup_uri
    else
      redirect_to payment.redirect_uri
    end

  end

end