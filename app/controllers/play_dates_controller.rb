class PlayDatesController < ApplicationController
  before_action :validate_params, only: :create

  def new
    @user_dogs = DogFacade.user_dogs(current_user.id)
    @location = params[:location_id]
  end

  def create
    json = PlayDateSerializer.serialize(playdate_params.merge(playdate_extra_params))
    response = PlayDateFacade.create_play_date(json)
    require "pry"; binding.pry
    if response.key?(:error)
      invalid_redirect('Invalid dog id')
    else
      clear_invited_dog
      redirect_to dashboard_path, success: 'Playdate created, bring your poop bags!'
    end
  end

  private

  def playdate_extra_params
    {
      token: current_user.token,
      email: current_user.email,
      invited_dog_id: cookies[:invited_dog]
    }
  end

  def playdate_params
    params.permit(:date, :time, :creator_dog_id, :location_id)
  end

  def clear_invited_dog
    cookies.delete(:invited_dog)
  end

  def valid_date?
    params[:date].present? && Date.today < Date.parse(params[:date])
  end

  def required_params?
    params[:date].present? && params[:time].present? && params[:creator_dog_id].present?
  end

  def validate_params
    # invalid_redirect('Invalid params') unless required_params? && valid_date?
  end

  def invalid_redirect(message)
    redirect_to new_play_date_path, alert: message
  end
end
