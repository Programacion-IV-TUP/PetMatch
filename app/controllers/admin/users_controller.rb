module Admin
  class UsersController < ApplicationController
    before_action :set_user, only: %i[show edit update destroy]
    before_action :authorize_admin!, only: %i[index new create destroy]
    before_action :authorize_user_access!, only: %i[show edit update]

    def index
      @users = User.includes(:address, :shelter).order(:last_name, :first_name)
    end

    def show
    end

    def new
      @user = User.new(role: :shelter_manager)
      @user.build_address
    end

    def create
      @user = User.new(user_params)
      @user.role = :shelter_manager unless current_user.admin? && params[:user][:role].present?

      if @user.save
        redirect_to admin_users_path, notice: t(".success")
      else
        @user.build_address unless @user.address
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @user.build_address unless @user.address
    end

    def update
      if user_params[:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end

      if @user.update(user_params)
        target_path = current_user.admin? ? admin_users_path : edit_admin_user_path(@user)
        redirect_to target_path, notice: t(".success")
      else
        @user.build_address unless @user.address
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
      redirect_to admin_users_path, notice: t(".success")
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def authorize_admin!
      unless current_user&.admin?
        redirect_to admin_root_path, alert: t("admin.shared.unauthorized")
      end
    end

    def authorize_user_access!
      return if current_user.admin?
      return if current_user == @user

      redirect_to admin_root_path, alert: t("admin.shared.unauthorized")
    end

    def user_params
      allowed_params = [
        :first_name,
        :last_name,
        :email_address,
        :phone,
        :password,
        :password_confirmation,
        :avatar,
        address_attributes: %i[id street number floor apartment zip_code city_id]
      ]

      allowed_params += %i[role shelter_id] if current_user&.admin?

      params.require(:user).permit(allowed_params)
    end
  end
end
