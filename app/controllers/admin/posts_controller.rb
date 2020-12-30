# frozen_string_literal: true

module Admin
  class PostsController < AdminsController
    before_action :authorize_admin

    def index; end

    def show
      post = Post.find_by_id(params[:id])

      return not_found if post.nil?

      ok(post)
    end

    def create
      post = Post.new(post_params)

      if post.valid?
        post.save
        ok(post)
      else
        unprocessable_entity(post.errors)
      end
    end

    private

    def post_params
      params.permit(
        :title,
        :content,
      )
    end
  end
end
