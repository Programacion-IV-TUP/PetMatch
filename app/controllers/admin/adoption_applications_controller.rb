module Admin
  class AdoptionApplicationsController < ApplicationController
    before_action :set_application, only: %i[show update]

    def index
      @adoption_applications = scoped_applications.includes(:pet, :user).order(created_at: :desc)
    end

    def show
    end

    def update
      if @application.update(application_params)
        redirect_to admin_adoption_application_path(@application), notice: t(".success")
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    # Restricts adoption applications based on user role:
    # - Admins can view all applications in the system.
    # - Shelter managers can only view applications for pets in their assigned shelter.
    def scoped_applications
      if current_user.admin?
        AdoptionApplication.all
      else
        current_shelter.adoption_applications
      end
    end

    # Finds an application within the user's scope.
    def set_application
      @application = scoped_applications.find(params[:id])
    end

    def application_params
      # In the Back-Office, admins or shelter managers can only modify the status or notes
      params.require(:adoption_application).permit(:status, :notes)
    end
  end
end
