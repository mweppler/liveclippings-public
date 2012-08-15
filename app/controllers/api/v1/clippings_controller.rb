
module Api
  module V1
    class ClippingsController < ApplicationController

      before_filter :restrict_access

      respond_to :json

      def index
        respond_with Clipping.where('user_id = ?', @user.id)
      end

      # def show
      #   binding.pry
      #   respond_with Clipping.where('user_id = ? AND id = ?', @user.id, params[:id])
      # end
      # 
      # def create
      #   binding.pry
      #   # @user
      #   respond_with Clipping.create(params[:clipping])
      # end
      # 
      # def update
      #   binding.pry
      #   # @user
      #   respond_with Clipping.update(params[:id], params[:clipping])
      # end
      # 
      # def destroy
      #   binding.pry
      #   # @user
      #   respond_with Clipping.destroy(params[:id])
      # end

      private

      def restrict_access
        @user = User.where('api_token = ?', params[:api_token]).first
        head :unauthorized unless @user
      end

    end
  end
end
