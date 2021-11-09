class UsersController < ApplicationController
  before_action :validate_user

  def edit; end

  def show
    @dogs = DogFacade.user_dogs(current_user.id)
  end

  def update
    current_user.update(location: params[:location])
    redirect_to dashboard_path
  end
end
