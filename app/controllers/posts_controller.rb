# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authorize_request

  def index
    page = params[:page]
    per = params[:per_page]

    posts = Post.order(:created_at).page(page).per(per)

    render json: {
      data: posts,
      meta: {
        total_pages: posts.total_pages,
        records: posts.total_count
      }
    }
  end

  def show
    post = Post.find_by_id(params[:id])

    return not_found if post.nil?

    ok(post)
  end
end
