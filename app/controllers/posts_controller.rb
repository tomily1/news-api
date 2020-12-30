# frozen_string_literal: true

class AdminsController < ApplicationController
  before_action :authorize_request

  def index
    page = params[:page]
    per = params[:per_page]

    post = Post.order(:created_at).page(page).per(per)

    render json: { data: posts, meta: { total_pages: post.total_pages, records: post.total_count } }
  end

  def show
    post = Post.find_by_id(params[:id])

    return not_found if post.nil?

    ok(post)
  end
end
