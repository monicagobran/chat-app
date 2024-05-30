class ApplicationController < ActionController::Base
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    private

    def record_not_found(exception)
        model_name = exception.model.constantize.model_name.human
        render json: { error: "#{model_name} not found" }, status: :not_found
    end
end
