class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end






  def index
    # Part 1
    sort = params[:sort] || session[:sort]
    case sort
    when 'title'
      ordering            = {:title => :asc}
      @title_header       = 'hilite'
    when 'release_date'
      ordering            = {:release_date => :asc}
      @date_header        = 'hilite'
    end
    
    # Part 2
    @all_ratings          = Movie.all_ratings
    @selected_ratings     = params[:ratings] || session[:ratings] || {}
    
    if @selected_ratings == {}
      @selected_ratings   = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    
    # Part 3
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort]      = sort
      session[:ratings]   = @selected_ratings
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    
    
    @movies = Movie.order(ordering).where(rating: @selected_ratings.keys)
    
  end







  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
