# frozen_string_literal: true

# app/controllers/desks_controller.rb
class DesksController < ApplicationController
  before_action :load_desk, only: [:show, :update, :destroy]

  def index
    @desks = Desk.all

    render(jsonapi: @desks)
  end

  def show
    render(jsonapi: @desk)
  end

  def create
    desk = Desk.new(desk_params)

    with_model_errors_handling do
      desk.save!

      render(jsonapi: desk, status: :created)
    end
  end

  def update
    with_model_errors_handling do
      desk.update!(desk_params)

      render(jsonapi: @desk)
    end
  end

  def destroy
    with_model_errors_handling do
      @desk.destroy!

      head(:no_content)
    end
  end

  private

  def load_desk
    @desk = Desk.find(params[:id])
  end

  def desk_params
    params.require(:desk).permit(:name)
  end
end
