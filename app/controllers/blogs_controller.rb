class BlogsController < ApplicationController
layout 'static'	
	def index
	  @blog_categories = BlogCategory.all
	  if params[:id]
      # get all records with id less than 'our last id'
      # and limit the results to 5
      @blogs = Blog.where('id < ?', params[:id]).limit(8)
    else
     @blogs = Blog.limit(8)
    end
    respond_to do |format|
      format.html
      format.js
    end
	end


	def show
	  @blog = Blog.find(params[:id])
	  @blogs = Blog.all
	end

  def about
  end

  def theme_show
  @blog_categories = BlogCategory.all
    if params[:id]
      # get all records with id less than 'our last id'
      # and limit the results to 5
      @blogs = BlogCategory.find(params[:t_id]).blogs.where('id < ?', params[:id]).limit(8)
    else
     @blogs = BlogCategory.find(params[:t_id]).blogs.limit(8)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end 
end
