module Api
  module V1
    class PostController < ApplicationController
      include Pagination
      before_action :set_post, only: [:update, :show, :destroy]


      def create
        post = Post.new(post_params)

        post.author = current_user
        response = nil
        Post.transaction do
          begin
            post.save!
            PostDeletionJob.perform_in(post.created_at + 24.hours, post.id)

            response = {
              json: {
                success: true,
                message: "Post created successfully",
                data: post,
                status: 201
              },
              status: :created
            }
          rescue StandardError => e
            Rails.logger.error(e)
            response = {
              json: {
                success: false,
                message: e.message,
                status: 500
              },
              status: :internal_server_error
            }
            raise ActiveRecord::Rollback
          end
        end
        render response
      end

      def index
        @posts = Post.includes(:tags, author: { image_attachment: :blob })
                     .order(created_at: :desc)
                     .then(&paginate)

        total_count = Post.count

        render json: {
          success: true,
          message: "Posts fetched successfully",
          data: @posts.as_json(
            include: {
              tags: { only: [:id, :name] },
              author: {
                only: [:id, :name],
                methods: [:image_url]
              }
            }
          ),
          meta: {
            current_page: page_no,
            per_page: per_page,
            total_count: total_count,
            total_pages: (total_count / per_page.to_f).ceil
          }
        }, status: :ok
      end


      def show
        render json: {
          success: true,
          message: "Post fetched successfully",
          data: @post.as_json(
            include: {
              tags: { only: [:id, :name] },
              author: {
                only: [:id, :name],
                methods: [:image_url]
              }
            }
          )
        }, status: :ok
      end

      def update
        if @post.author_id != current_user.id
          return render_unauthorized("You are not authorized to edit this post")
        end

        if @post.update(post_params)
          render_success(@post, "Post updated successfully")
        else
          render_unprocessable_entity(@post.errors)
        end
      end

      def destroy
        if @post.author_id != current_user.id
          return render_unauthorized("You are not authorized to delete this post")
        end

        @post.destroy
        render_success(nil, "Post deleted successfully")
      end

      private

      def post_params
        params.permit(:title, :body, :tag_ids => [])
      end

      def set_post
        @post = Post.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render_not_found("Post not found")
      end

    end
  end
end
