class ApplicationsController < ApplicationController
    protect_from_forgery with: :null_session

    def create_response(object)
      render :json => object, :except => [:id], status: :ok
    end
    
    def create
        application = Application.new(application_params)
        if application.save
          create_response application
        else
          render json: application.errors, status: :unprocessable_entity
        end
      end
    
      def show
        application = Application.find_by(token: params[:token])
        create_response application
      end
    
      def update
        application = Application.find_by(token: params[:token])
        if application.update(application_params)
          create_response application
        else
          render json: application.errors, status: :unprocessable_entity
        end
      end

      def index
        applications = Application.all
        create_response applications
      end
    
      private
    
      def application_params
        params.require(:application).permit(:name)
      end
end
