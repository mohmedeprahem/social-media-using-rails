module Api
  module V1
    class CommentController < ApplicationController
      include Pagination

      before_action :set_comment, only: [:update, :destroy]
      before_action :set_post

      def index
        @comments = Comment.includes(:author)
        .where(post_id: params[:post_id])
        .order(created_at: :desc)
        .then(&paginate)

        count = Comment.count


        render json: {
          success: true,
          message: "Comments fetched successfully",
          status: 200,
          data: @comments,
          meta: {
            current_page: page_no,
            per_page: per_page,
            total_count: count,
            total_pages: (count / per_page.to_f).ceil
          }
        }, status: :ok
      end

      def create
        @comment = Comment.new(comment_params)
        @comment.post_id = params[:post_id]
        @comment.author = current_user
        if @comment.save
          render_success(@comment, "Comment created successfully")
        else
          render_unprocessable_entity(@comment.errors)
        end
      end

      def update
        if @comment.author_id != current_user.id
          render_unauthorized("You are not authorized to edit this comment")
        end

        if @comment.update(comment_params)
          render_success(@comment, "Comment updated successfully")
        else
          render_unprocessable_entity(@comment.errors)
        end
      end

      def destroy
        if @comment.author_id != current_user.id
          render_unauthorized("You are not authorized to delete this comment")
        end

        @comment.destroy
        render_success(nil, "Comment deleted successfully")
      end

      private

      def set_comment
        @comment = Comment.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render_not_found("Comment not found")
      end

      def set_post
        @post = Post.find(params[:post_id])
      rescue ActiveRecord::RecordNotFound
        render_not_found("Post not found")
      end

      def comment_params
        params.permit(:content)
      end
    end
  end
end
