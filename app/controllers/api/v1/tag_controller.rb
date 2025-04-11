module Api
  module V1
    class TagController < ApplicationController
      def index
        @tags = Tag.all
        render json: {
          success: true,
          message: "Tags fetched successfully",
          data: @tags
        }, status: :ok
      end
    end
  end
end
