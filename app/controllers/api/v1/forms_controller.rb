class Api::V1::FormsController < ApplicationController
  def index
    render json: current_user.forms, status: :ok
  end

  def new
    @form = Form.new
  end

  def create
    form =  current_user.forms.new(form_params)
    if form.save
      render json: form, status: :created
    else
      render json: { error: form.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    form = current_user.forms.find(params[:id])
    if (form.nil?)
      render json: { error: "Form not found" }, status: :not_found
      return
    end

    render json: form, status: :ok
  end

  def delete
    form = current_user.forms.find(params[:id])
    if (form.nil?)
      render json: { error: "Form not found" }, status: :not_found
      return
    end
    form.destroy
    render json: { message: "Form deleted" }, status: :ok
  end

  def update
    form = current_user.forms.find(params[:id])
    if (form.nil?)
      render json: { error: "Form not found" }, status: :not_found
      return
    end
    if form.update(form_params)
      render json: form, status: :ok
    else
      render json: { error: form.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def form_params
    params.require(:form).permit(:name, :title, :description, :active)
  end
end
