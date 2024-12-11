# frozen_string_literal: true

module Api
  class CompaniesController < Api::ApplicationController
    before_action :set_company, only: %i[show update destroy restore]

    def index
      @companies = Company.all
      render json: data_serializer(@companies)
    end

    def show
      render json: data_serializer(@company)
    end

    def create
      response = Company::Creator.call(company_params)

      if response.ok?
        render json: data_serializer(response.result), status: :created
      else
        render json: { errors: response.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @company.update(company_params)
        render json: data_serializer(@company)
      else
        render json: { errors: @company.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      if @company.discard
        render json: data_serializer(@company), status: :ok
      else
        render json: { errors: @company.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def restore
      if @company.undiscard
        render json: data_serializer(@company), status: :ok
      else
        render json: { errors: @company.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      params.require(:company).permit(
        :name, :trade_name, :email, :website_facebook,
        :business_description, :status,
        metadata: {}
      )
    end
  end
end
