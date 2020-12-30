# frozen_string_literal: true

module Admin
  class PostsController < AdminsController
    before_action :authorize_admin

    def create
      post = Post.new(post_params)

      if post.valid?
        post.save
        ok(post, :created)
      else
        unprocessable_entity(post.errors)
      end
    end

    private

    def post_params
      params.permit(
        :title,
        :content
      )
    end
  end
end
